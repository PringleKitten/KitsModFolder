/****
* Copyright (c) 2013 Jason O'Neil
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
****/

package dtx.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Format;
import haxe.macro.Printer;
import haxe.macro.Type;
import sys.io.File;
import tink.macro.ClassBuilder;
using tink.MacroApi;
using StringTools;
using Lambda;
using Detox;

#if macro

/**
	A collection of helper utilities used in the widget macros.

	Most of this should be replaced by the much better designed `tink_macros` as well as Haxe's built in `reification` feature.

	I recommend against using this class for any outside projects.
**/
class BuildTools {
	static var fieldsForClass:Map<String, Array<Field>> = new Map();

	/**
		Return the position of the current class definition.
	**/
	public static function currentPos():Position {
		return Context.getLocalClass().get().pos;
	}

	/**
		Allow us to get a list of fields, but will keep a local copy, in case we make changes.
		This way in an autobuild macro you can use BuildTools.getFields() over and over, and modify the array each time.
		We also apply the `makeComplexTypeAbsolute` transformation to any ComplexTypes in the field signiature.
		This makes it easier to reference the ComplexType from outside (for example, in a new TypeDefinition) and not have it break because the new definition doesn't share the same local imports.
		Finally, we can use it as the return value of the build macro.
	**/
	public static function getFields():Array<Field> {
		var className = haxe.macro.Context.getLocalClass().toString();
		if (fieldsForClass.exists(className) == false)
		{
			var fields = [];
			for ( field in Context.getBuildFields() ) {
				var kind:FieldType = switch field.kind {
					case FVar(ct,e): FVar(makeComplexTypeAbsolute(ct),e);
					case FProp(get,set,ct,e): FProp(get,set,makeComplexTypeAbsolute(ct),e);
					case FFun(f): FFun({
						ret: makeComplexTypeAbsolute(f.ret),
						params: f.params,
						expr: f.expr,
						args: [
							for (arg in f.args) {
								value: arg.value,
								type: makeComplexTypeAbsolute(arg.type),
								opt: arg.opt,
								name: arg.name
							}
						],
					});
				}
				field.kind = kind;
				fields.push( field );
			}
			fieldsForClass.set(className, fields);
		}
		return fieldsForClass.get(className);
	}

	/**
		Attempt to transform a ComplexType to use an absolute TypePath, so local imports are included in the CT.
		This works by transforming the ComplexType into a Type, and then converting it back again.
		If the operation fails, the original ComplexType is returned.
	**/
	public static function makeComplexTypeAbsolute( ct:ComplexType ):ComplexType
	{
		if (ct==null) return null;
		switch ct.toType() {
			case Success(type): return type.toComplex();
			case Failure(err): return ct;
		}
	}

	/**
		While a class is being built, it's ClassType has an empty fields array.
		This returns an Iterable (read-only) on any fields which may (or may not be) cached from calling `BuildTools.getFields()`.
		This allows you to retrieve a copy of the fields that are half way through building.
	**/
	public static function getFieldsForClass( className:String ):Iterable<Field> {
		return fieldsForClass.exists(className) ? fieldsForClass.get(className) : [];
	}

	/**
		See if a field with the given name exists.
	**/
	public static function fieldExists( name:String ) {
		return getFields().exists( function (f) return f.name==name );
	}

	/**
		Return a field, assuming it already exists
	**/
	public static function getField( name:String ) {
		return getFields().filter( function (f) return f.name==name )[0];
	}

	/** Return a field, assuming it already exists */
	public static function getFieldFromSuperClass(name:String):Option<ClassField>
	{
		var superClass = Context.getLocalClass().get().superClass;
		while ( superClass!=null ) {
			var cls = superClass.t.get();
			for ( f in cls.fields.get() ) {
				if ( f.name==name ) return Some( f );
			}
			superClass = cls.superClass;
		}
		return None;
	}

	/**
		Get the fully qualified name for a type, or null if not found
	**/
	public static function getFullTypeName( t:haxe.macro.Type ):Null<String> {
		switch t {
			case TMono( ref ):
				return ref.toString();
			case TEnum( ref, _ ):
				return ref.toString();
			case TInst( ref, _ ):
				return ref.toString();
			case TType( ref, _ ):
				return ref.toString();
			case TAnonymous( ref ):
				return ref.toString();
			case TAbstract( ref, _ ):
				return ref.toString();
			case _:
				return null;
		}
	}

	/**
		Return a setter from a field.

		If it is a FProp, it returns the existing setter, or creates one if it did not have a setter already.

		If it is a FVar, it will transform it into FProp(default,set) to create the setter and return it.

		If it is a FFun, an error is thrown.
	**/
	public static function getSetter( field:Field, cb:ClassBuilder ) {
		switch field.kind {
			case FProp( _, _, t, _ ) | FVar( t,_ ):
				return getOrCreateProperty( cb, field.name, t, false, true ).setter;
			case FFun( _ ):
				return throw 'Was expecting ${field.name} to be a var or property, but it was a function.';
		}
	}

	public static function hasClassMetadata( dataName:String, recursive=false, ?cl:Ref<ClassType> ):Bool {
		var p = currentPos();
		var localClass = (cl==null) ? Context.getLocalClass() : cl;
		var meta = localClass.get().meta;

		if ( meta.has(dataName) ) {
			return true;
		}
		else if ( recursive ) {
			// Check if there is a super class, and check recursively for metadata
			if ( localClass.get().superClass!=null ) {
				var superClass = localClass.get().superClass.t;
				if ( hasClassMetadata(dataName,true,superClass) ) return true;
			}
		}
		return false;
	}

	/**
		Searches the metadata for the current class - expects to find a single string @dataName("my string"), returns null in none found.  Generates an error if one was found but it was the wrong type. Can search recursively up the super-classes if 'recursive' is true
	**/
	public static function getClassMetadata_String( dataName:String, recursive=false, ?cl:Ref<ClassType> ):String {
		var array = getClassMetadata_ArrayOfStrings( dataName, recursive, cl );
		return ( array!=null && array.length>0 ) ? array[0] : null;
	}

	/**
		Searches the metadata for the current class - expects to find one or more strings @dataName("my string", "2nd string"), returns empty array in none found.  Generates an error if one was found but it was the wrong type. Can search recursively up the super-classes if 'recursive' is true
	**/
	public static function getClassMetadata_ArrayOfStrings( dataName:String, recursive=false, ?cl:Ref<ClassType> ):Array<String> {
		var p = currentPos();
		var localClass = (cl==null) ? Context.getLocalClass() : cl;
		var meta = localClass.get().meta;
		var result = [];
		if ( meta.has(dataName) ) {
			for ( metadataItem in meta.get() ) {
				if ( metadataItem.name==dataName ) {
					if ( metadataItem.params.length==0 )
						Context.error( 'Metadata @$dataName() exists, but was empty.', p );

					for ( targetMetaData in metadataItem.params ) {
						switch targetMetaData.expr {
							case EConst( CString(str) ):
								result.push(str);
							default:
								Context.error( 'Metadata for $dataName() existed, but was not a constant String.', p );
						}
					}
				}
			}
		}
		else if (recursive) {
			// Check if there is a super class, and check recursively for metadata
			if ( localClass.get().superClass!=null ) {
				var superClass = localClass.get().superClass.t;
				result = getClassMetadata_ArrayOfStrings( dataName, true, superClass );
			}
		}
		return result;
	}

	/**
		Takes a field declaration, and if it doesn't exist, adds it.
		If it does exist, it returns the existing one.
	**/
	public static function getOrCreateField( cb:ClassBuilder, fieldToAdd:Field ) {
		var p = currentPos();
		var localClass = Context.getLocalClass();
		var fields = getFields();

		if ( cb.hasOwnMember(fieldToAdd.name) ) {
			// If it does exist, get it
			return getField( fieldToAdd.name );
		}
		else {
			// If it doesn't exist, create it
			fields.push( fieldToAdd );
			cb.addMember( fieldToAdd );
			return fieldToAdd;
		}
	}

	/**
		Gets an existing (or creates a new) property on the class, with the given name and type.
		Optionally can set a setter or a getter.

		If the property already exists and was explicitly typed, it will not be changed.

		If the property already exists and is a FVar, it will be transformed into a FProp

		If the property already exists and is a FProp, the existing setter and getter will be used.

		Returns a simple object containing the fields for the property, the setter and the getter.
	**/
	public static function getOrCreateProperty( cb:ClassBuilder, propertyName:String, propertyType:ComplexType, useGetter:Bool, useSetter:Bool ):{ property:Field, getter:Field, setter:Field } {
		var p = currentPos();

		var getterString = useGetter ? "get_" + propertyName : "default";
		var setterString = useSetter ? "set_" + propertyName : "default";
		var variableRef = propertyName.resolve();

		// Set up the property
		var property = getOrCreateField( cb, {
			pos: p,
			name: propertyName,
			meta: [],
			kind: FieldType.FProp( getterString, setterString, propertyType ),
			doc: "Field referencing the " + propertyName + " partial in this widget.",
			access: [APublic]
		});

		switch property.kind {
			case FieldType.FProp( get, set, t, _ ):
				// Read the getter / setter string, in case it already exists and was different
				getterString = get;
				setterString = set;
				propertyType = t;
			case FieldType.FVar( type,expr ):
				// This was originally a function or a var, change it to a property
				// For now we will respect the type found in the class, not the one asked for by this function
				// If there's demand I might change my mind on this...
				property.kind = FieldType.FProp( getterString, setterString, type, expr );
				propertyType = type;
			case FieldType.FFun( _ ):
				var className = Context.getLocalClass().toString();
				var msg = 'Trying to create a property called $propertyName on class $className but a function with the same name already exists.';
				Context.error( msg, currentPos() );
		}

		// Set up the getter
		var getter = null;
		if (useGetter) {
			var getterBody = macro {
				// Just return the current value... If they want to add lines to this function later then they can.
				return $variableRef;
			};
			getter = getOrCreateField( cb, {
				pos: p,
				name: getterString,
				meta: [],
				kind: FieldType.FFun({
						ret: propertyType,
						params: [],
						expr: getterBody,
						args: []
					}),
				doc: "",
				access: []
			});
		}

		// set up the setter
		var setter = null;
		if (useSetter) {
			var setterBody = macro {
				$variableRef = v;
				return v;
			};
			setter = getOrCreateField( cb, {
				pos: p,
				name: setterString,
				meta: [],
				kind: FieldType.FFun({
						ret: propertyType,
						params: [],
						expr: setterBody,
						args: [{
							value: null,
							type: propertyType,
							opt: false,
							name: "v"
						}]
					}),
				doc: "",
				access: []
			});
		}

		return {
			property: property,
			getter: getter,
			setter: setter
		}
	}

	/**
		Add some lines of code to the function body.

		It takes a field (that is a function) as the first argument, and an expression as the second.
		For now, Haxe expects a block to be passed, and then it will go over each line in the block and add them to the function.
		Finally you can choose where to add the lines in the function body:

		- `-1`: Place them at the end (default)
		- `0`: Place them at the start
		- `1` or more: Insert them at a set position (0 based index)

		Sample usage:

		```
		var myFn = BuildTools.getOrCreateField(...);
		var linesToAdd = macro {
			for ( i in 0...10 ) {
				trace (i);
			}
		};
		BuildTools.addLinesToFunction( myFn, linesToAdd );
		```
	*/
	public static function addLinesToFunction( field:Field, lines:Expr, ?whereToAdd=-1 ) {
		// Get the function from the field, or throw an error
		var fn = null;
		switch field.kind {
			case FFun( f ):
				fn = f;
			default:
				Context.error( "addLinesToFunction was sent a field that is not a function.", currentPos() );
		}

		// Get the "block" of the function body
		var body = null;
		switch fn.expr.expr {
			case EBlock( b ):
				body = b;
			default:
				Context.error( "addLinesToFunction was expecting an EBlock as the function body, but got something else.", currentPos() );
		}

		addLinesToBlock( body, lines, whereToAdd );
	}

	/**
		Same as addLinesToFunction, but works on an arbitrary EBlock array.
	**/
	public static function addLinesToBlock( block:Array<Expr>, lines:Expr, ?whereToAdd=-1 ) {
		// Get an array of the lines we want to add...
		var linesArray:Array<Expr> = [];
		switch lines.expr {
			case EBlock( b ):
				// If it's a block, use each statement in the block
				for ( line in b )
					linesArray.push( line );
			default:
				// Otherwise, include it as a single item
				linesArray.push( lines );
		}

		// Add the lines, put them at the end by default
		if ( whereToAdd<0 )
			whereToAdd = block.length;

		linesArray.reverse();

		for ( line in linesArray )
			block.insert( whereToAdd, line );
	}

	/**
		Extract all the idents in an expression.
	**/
	public static function extractIdents( expr:Expr ):Array<String> {
		var parts = [];
		var getIdent:Expr->Void = null;
		getIdent = function ( e ) {
			switch e.expr {
				case EConst( CIdent(s) ):
					// If first letter is capital, it's a Type. If not, it's an ident. Only add idents
					if ( s.charAt(0) != s.charAt(0).toUpperCase() )
						if ( s!="null" && s!="true" && s!="false" )
							parts.push( s );
				case _:
					e.iter( getIdent );
			}
		}
		getIdent( expr );
		return parts;
	}

	/**
		Given a list of idents, generate a `(ident1!=null && ident2!=null)` type expression.
		If there are no idents, it will return `true` as an expression so you can still safely use it.
	**/
	public static function generateNullCheckForIdents( idents:Array<String> ) {
		var exprs = [ for (i in idents) i.resolve() ];
		var checks = [];
		addNullCheckForMultipleExprs( exprs, checks );
		return
			if ( checks.length==0 ) macro true;
			else combineExpressionsWithANDBinop( checks );
	}

	/**
		Check if the current compilation target is one of our static platforms: cpp, flash, java or cs.
	**/
	public static function isStaticPlatform():Bool {
		return Context.defined("cpp") || Context.defined("flash") || Context.defined("java") || Context.defined("cs");
	}

	/**
		Convert an expression into an ECheckType which casts it to Null<T>.

		On static platforms basic types (Int,Float,Bool) cannot be compared to null.
		This method wraps expressions in an ECheckType which casts them from `T` to `Null<T>`, so we can perform a comparison.

		On dynamic platforms this has no effect as every value is nullable.

		It would be better to avoid adding the null check for these types.
		If someone can think of an implementation that would work here, please let me know!
	**/
	public static function nullableCast<T>(expr:ExprOf<T>):ExprOf<Null<T>> {
		if ( isStaticPlatform() ) {
			expr = macro ($expr:Null<Dynamic>);
		}
		return expr;
	}

	/**
		Given an expression, null check all idents / field access.

		For example, the expression `result.name.first` will generate `result!=null && result.name!=null && result.name.first!=null`
	**/
	public static function generateNullCheckForExpression( expr:Expr/*, ?existingExpr:ExprOf<Bool>*/ ):ExprOf<Bool> {


		var checks:Array<ExprOf<Bool>> = [];
		addNullCheckForExpr( expr, checks );

		// We have to be careful with the order, when checking "some.field.access", we want to generate `some!=null && some.field!=null && some.field.access!=null )`.
		// This will prevent invalid field access if "some.field" is null but we accidentally checked "some.field.access" first.
		// When we add field accesses, we added them in deepest->shallowest order, so here, we should reverse that order before combining them.
		checks.reverse();

//		if ( existingExpr!=null )
//			checks.unshift( existingExpr );

		return
			if ( checks.length==0 ) macro true;
			else combineExpressionsWithANDBinop( checks );
	}

	/**
		For an array of expressions, create null checks for each part of each expression.
	**/
	static function addNullCheckForMultipleExprs( exprs:Array<Expr>, allChecks:Array<Expr> ):Void {
		for ( e in exprs ) {
			addNullCheckForExpr( e, allChecks );
		}
	}

	/**
		For an expression, create null checks for each part of the expression recursively.
	**/
	static function addNullCheckForExpr( expr:Expr, allChecks:Array<Expr> ):Void {
		switch expr.expr {
			case EConst(CIdent(name)):
				if ( name!="null" && name!="false" && name!="true" ) {
					var nullableExpr = nullableCast(expr);
					allChecks.push( macro $nullableExpr!=null );
				}
			case EConst(_):
				// Don't need to add any checks.
			case EField(e,field):
				var nullableExpr = nullableCast(expr);
				allChecks.push( macro $nullableExpr!=null );
				addNullCheckForExpr( e, allChecks );
			case ECheckType(e,type):
				addNullCheckForExpr( e, allChecks );
			case EBinop(_,expr1,expr2):
				addNullCheckForExpr( expr1, allChecks );
				addNullCheckForExpr( expr2, allChecks );
			case EUnop(_,_,e):
				addNullCheckForExpr( e, allChecks );
			case ECall({ expr: EField(objExpr,fnName), pos: _ },params):
				addNullCheckForExpr( objExpr, allChecks );
				addNullCheckForMultipleExprs( params, allChecks );
			case ECall({ expr: EConst(CIdent(name)), pos: _ }, params):
				allChecks.push( macro $i{name}!=null );
				addNullCheckForMultipleExprs( params, allChecks );
			case EArrayDecl( exprs ):
				addNullCheckForMultipleExprs( exprs, allChecks );
			case EObjectDecl( fields ):
				var exprs = [ for (f in fields) f.expr ];
				addNullCheckForMultipleExprs( exprs, allChecks );
			case EArray( arr, index ):
				addNullCheckForExpr( arr, allChecks );
				addNullCheckForExpr( index, allChecks );
			case ETernary( cond, ifExpr, elseExpr ):
				// Often this is used for an (a!=null ? a : "fallback"), so null checking really isn't practical here
			case unsupportedType:
				var typeName = std.Type.enumConstructor( unsupportedType );
				Context.fatalError( 'Unable to generate null check for `${expr.toString()}`, field access from "$typeName" is currently not supported.', Context.getLocalClass().get().pos );
		}
	}

	/**
		Combine many expressions with the `&&` binop.

		Example: [expr1,expr2,expr3] becomes `expr1 && expr2 && expr3`.

		This will filter any duplicate expressions so they are only included once.
	**/
	static function combineExpressionsWithANDBinop( exprs:Array<Expr> ):ExprOf<Bool> {
		var completeCheck:ExprOf<Bool> = null;

		var filteredExprs:Array<ExprOf<Bool>> = [];
		var filteredExprStrings:Array<String> = [];

		for ( e1 in exprs ) {
				filteredExprs.push( e1 );
		}

		while ( filteredExprs.length>0 ) {
			var check = filteredExprs.shift();
			completeCheck = (completeCheck==null) ? check : macro $completeCheck && $check;
		}
		return completeCheck;
	}

	/**
		Takes a bunch of Binop functions `x + " the " + y + 10` and returns an array of each part.
	**/
	public static function getAllPartsOfBinOp( binop:Expr ):Array<Expr> {
		var parts:Array<Expr> = [];

		// Try get the binop out of this expression
		switch binop.getBinop() {
			case Success(data):

				// Add part 2
				parts.unshift( data.e2 );

				// Add part 1, recursively checking for more Binops
				switch data.e1.expr {
					case EBinop( _, _, _ ):
						// It's another Binop, get all the parts and add them each...
						for ( p in getAllPartsOfBinOp(data.e1) ) {
							parts.unshift( p );
						}
					default:
						// Just add this expression to our array
						parts.unshift( data.e1 );
				}

			case Failure(failure):
				throw failure;
		}
		return parts;
	}

	/**
		Reads a file, relative either to the project class paths, or relative to the local class.
		It will try an absolute path first (testing against each of the class paths), and then a relative path, testing for a file in the same package location as the current class.
	**/
	public static function loadFileFromLocalContext( filename:String ):String {
		var fileContents = null;
		var path:String;
		try {
			path = Context.resolvePath(filename);
			fileContents = File.getContent(path);
		}
		catch ( e:Dynamic ) {
			try {
				var modulePath = Context.getPosInfos(Context.getLocalClass().get().pos).file;
				var moduleDir = Path.directory(modulePath);
				path = Context.resolvePath(Path.addTrailingSlash(moduleDir)+filename);
				fileContents = File.getContent(path);
			}
			catch ( e:Dynamic ) {
				if ( e.indexOf("File not found")==1 )
					trace( e );
				path = null;
			}
		}
		if ( path!=null )
			Context.registerModuleDependency(Context.getLocalModule(),path);
		return fileContents;
	}

	/**

	**/
	public static function getFieldsFromAnonymousCT( ct:ComplexType ):Array<Field> {
		switch ct {
			case TAnonymous( fields ):
				return fields;
			case _:
				throw 'Was Expecting TAnonymous, but got something else: $ct';
				return null;
		}
	}
}

enum ExtractedVarType {
	Ident(name:String);
	Field(name:String);
	Call(name:String);
}
#end
