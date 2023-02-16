package dtx.macro;

import dtx.macro.WidgetBuilder;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Context.error;
import haxe.macro.Printer;
import tink.macro.ClassBuilder;
using tink.MacroApi;
using dtx.macro.BuildTools;

class WidgetMacroUtil {
	/**
		Detox's `innerHTML()` helper does not keep tag name case in tact.

		This function is a workaround that does keep it in tact.
	**/
	@:access(dtx.single.Traversing)
	@:access(dtx.single.ElementManipulation)
	public static function getInnerHtmlPreservingTagNameCase( elm:DOMNode ):String {

		var ret="";
		if ( elm!=null ) {
			switch elm.nodeType {

				case dtx.DOMType.ELEMENT_NODE:
					var sb = new StringBuf();
					for ( child in dtx.single.Traversing.unsafeGetChildren(elm,false) ) {
						dtx.single.ElementManipulation.printHtml( child, sb, true );
					}
					ret = sb.toString();

				default:
					ret = elm.textContent;
			}
		}
		return ret;

	}

	/**
		Takes the output of a String Interpolation expression, and searches for variables used...

		Basic implementation so far, it only supports:

		- basic EConst(CIdent(myvar))
		- the left-most variable / identifier in a field access (field must already exist in the class)
		- the left-most variable / identifier in a function call (the field must already exist in the class)
		- the left-most variable / identifier in each argument parsed to a function (the field must already exist in the class)

		TODO: refactor this to have a single switch statement, and use recursion, this will make it re-usable event outside of String Interpolation.
		TODO: once this is more generic, replace getLeftMostVariable, or at least check every place it is used - this is probably more useful (especially for fn calls).
	**/
	public static function extractVariablesUsedInInterpolation( expr:Expr ):Array<ExtractedVarType> {
		var variablesInside:Array<ExtractedVarType> = [];
		switch expr.expr {

			case ECheckType(e,_):
				switch e.expr {

					case EBinop(_,_,_):
						var parts = BuildTools.getAllPartsOfBinOp( e );
						for ( part in parts ) {
							switch part.expr {

								case EConst(CIdent(varName)):
									variablesInside.push( ExtractedVarType.Ident(varName) );

								case EField(e, field):
									// Get the left-most field, add it to the array
									var leftMostVarName = getLeftMostVariable(part);
									if ( leftMostVarName!=null ) {
										if ( leftMostVarName.fieldExists() ) {
											variablesInside.push( ExtractedVarType.Field(leftMostVarName) );
										}
										else {
											var localClass = Context.getLocalClass();
											var printer = new Printer("  ");
											var partString = printer.printExpr(part);
											error('In the Detox template for $localClass, in the expression `$partString`, variable "$leftMostVarName" could not be found.  Variables used in complex expressions inside the template must be explicitly declared.', localClass.get().pos);
										}
									}

								case ECall(e, params):
									// Look for variables to add in the paramaters
									for ( param in params ) {
										var varName = getLeftMostVariable(param);
										if ( varName!=null ) {
											if ( varName.fieldExists() ) {
												switch varName.getField().kind {
													case FVar(_,_), FProp(_,_,_,_):
														variablesInside.push( ExtractedVarType.Call(varName) );
													case FFun(_):
												}
											}
											else {
												var localClass = Context.getLocalClass();
												var printer = new Printer( "  " );
												var callString = printer.printExpr( part );
												error( 'In the Detox template for $localClass, in function call `$callString`, variable "$varName" could not be found.  Variables used in complex expressions inside the template must be explicitly declared.', localClass.get().pos );
											}
										}
									}
									// See if the function itself is on a variable we need to add
									var leftMostVarName = getLeftMostVariable(e);
									if ( leftMostVarName.fieldExists() ) {
										switch leftMostVarName.getField().kind {

											case FVar(_,_) | FProp(_,_,_,_):
												variablesInside.push( ExtractedVarType.Field(leftMostVarName) );

											case _:
										}
									}
									// else: don't throw error.  They might be doing "haxe.crypto.Sha1.encode()" or "Math.max(a,b)" etc. If they do something invalid the compiler will catch it, the error message just won't be as obvious

								default:
									// do nothing
							}
						}

					default:
						error( "extractVariablesUsedInInterpolation() only works when the expression inside ECheckType is EBinOp, as with the output of Format.format()", BuildTools.currentPos() );
				}

			default:
				error( "extractVariablesUsedInInterpolation() only works on ECheckType, the output of Format.format()", BuildTools.currentPos() );
		}

		return variablesInside;
	}

	/**
		Takes an expression and tries to find the left-most plain variable.  For example "student" in `student.name`, "age" in `person.age`, "name" in `name.length`.

		It will try to ignore "this", for example it will match "person" in `this.person.age`.

		Note it will also match packages: "haxe" in "haxe.crypto.Sha1.encode"
	**/
	public static function getLeftMostVariable( expr:Expr ):Null<String> {
		var leftMostVarName = null;
		var err = false;

		switch expr.expr {

			case EConst(CIdent(varName)):
				leftMostVarName = varName;

			case EField(e,field):
				// Recurse until we find it.
				var currentExpr = e;
				var currentName:String;
				while ( leftMostVarName==null ) {
					switch currentExpr.expr {

						case EConst(CIdent(varName)):
							if (varName == "this")
								leftMostVarName = currentName;
							else
								leftMostVarName = varName;

						case EField(e,field):
							currentName = field;
							currentExpr = e;

						case _:
							err = true;
							break;
					}
				}

			case ECall(e,params):
				// TODO: Here we only return the left-most variable of the function being called, which is useful
				// if we are calling a method on a variable.  For example, `student.name.substr(1)` will return `student`
				// so we can listen to set_student for changes.  But what if we have have `StringTools.replace(text, student.firstName, "")`?
				// In that case we might want this to return `[text, student]`, as we will want setters on both of those
				return getLeftMostVariable( e );

			case EMeta(_,e):
				return getLeftMostVariable( e );

			case EConst(_): // A constant.  Leave it null

			case _: err = true;
		}

		if (err) {
			var localClass = Context.getLocalClass();
			var printer = new Printer( "  " );
			var exprString = printer.printExpr( expr );
			error( 'In the Detox template for $localClass, the expression `$exprString`, was too complicated for the poor Detox macro to understand.', localClass.get().pos );
		}

		return leftMostVarName;
	}

	static var booleanSetters:Map<String,Map<String, { trueBlock:Array<Expr>, falseBlock:Array<Expr> }>> = null;

	/**
		For a given name, get (or create) a `var $name(default,set):Bool` field on the widget.

		This will set up the setter to have an `if ($expr) {} else {}` block, and return an object letting you modify the content of each of those blocks.
	**/
	public static function getBooleanSetterParts( cb:ClassBuilder, booleanName:String ):{ trueBlock:Array<Expr>, falseBlock:Array<Expr> } {

		// If a list of boolean setters for this class doesn't exist yet, set one up
		var className = Context.getLocalClass().toString();
		if (booleanSetters==null)
			booleanSetters = new Map();
		if ( booleanSetters.exists(className)==false )
			booleanSetters.set(className, new Map());

		// If this boolean setter doesn't exist yet, create it.
		if ( booleanSetters.get(className).exists(booleanName)==false ) {

			// get or create property
			var propType = TPath({
				sub: null,
				params: [],
				pack: [],
				name: "Bool"
			});
			var prop = BuildTools.getOrCreateProperty( cb, booleanName, propType, false, true );

			// add if() else() to setter, at position 1 (so after the this.x = x; statement)
			var booleanExpr = booleanName.resolve();
			var ifStatement = macro if ($booleanExpr) {} else {};
			BuildTools.addLinesToFunction( prop.setter, ifStatement, 1 );

			// get the trueBlock and falseBlock
			var trueBlock:Array<Expr>;
			var falseBlock:Array<Expr>;
			switch ifStatement.expr {

				case EIf(_,eif,eelse):

					switch eif.expr {
						case EBlock(b):
							trueBlock = b;
						default:
					}

					switch (eelse.expr)
					{
						case EBlock(b):
							falseBlock = b;
						default:
					}

				default:
			}

			// Keep track of them so we can use them later
			booleanSetters.get(className).set(booleanName, {
				trueBlock: trueBlock,
				falseBlock: falseBlock
			});
		}

		// get the if block and else block and return them
		return booleanSetters.get(className).get(booleanName);
	}
}