package dtx.macro.processor;

import dtx.macro.NodeProcessor;
import dtx.macro.WidgetMacroUtil;
import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Format;
using tink.MacroApi;
using dtx.macro.BuildTools;
using Detox;

/**
	A Processor...
**/
class InterpolationProcessor implements NodeProcessor {
	public function new() {}

	public function process( node:DOMNode, wb:WidgetBuilder ):NodeProcessorResult {
		var interpolationUsed = false;

		if ( node.isElement() ) {
			// check attributes for interpolation
			for ( attName in node.attributes() ) {
				var attValue = node.get( attName );
				if ( attValue.indexOf('$')>-1 ) {
					interpolationUsed = true;
					interpolateAttribute( wb, node, attName, attValue );
				}
			}
		}
		else if ( node.isTextNode() ) {
			// check text for interpolation
			var text = node.nodeValue;
			if ( text.indexOf('$')>-1 ) {
				interpolationUsed = true;
				interpolateTextNode( wb, node );
			}
		}

		return
			if ( interpolationUsed ) Affected( false, true );
			else NotAffected;
	}

	static function interpolateAttribute( wb:WidgetBuilder, node:DOMNode, attName:String, attValue:String ) {
		var selectorExpr = wb.getUniqueSelectorForNode( node );
		var nameAsExpr = Context.makeExpr( attName, wb.target.pos );

		var result = processVariableInterpolation( wb, node.attr(attName) );
		var interpolationExpr = result.expr;
		var variablesInside = result.variablesInside;

		// Set up bindingExpr
		var bindingExpr = macro dtx.single.ElementManipulation.setAttr( $selectorExpr, $nameAsExpr, $interpolationExpr );

		// Go through array of all variables again
		wb.addExprToAllSetters( bindingExpr, variablesInside, 0 );

		// Initialise variables
		wb.addMemberInitializationToConstructor( variablesInside );
	}

	static function interpolateTextNode( wb:WidgetBuilder, node:DOMNode ) {
		var selectorAsExpr = wb.getUniqueSelectorForNode( node.parent );
		var index = node.index();
		var indexAsExpr = index.toExpr();

		var result = processVariableInterpolation( wb, node.text() );
		var interpolationExpr = result.expr;
		var variablesInside = result.variablesInside;

		// Set up bindingExpr
		var bindingExpr = macro dtx.single.ElementManipulation.setText( dtx.single.Traversing.children($selectorAsExpr, false).getNode($indexAsExpr), $interpolationExpr );

		// Add binding expression to all setters.
		wb.addExprToAllSetters(bindingExpr, variablesInside, 0);

		// Initialise variables
		wb.addMemberInitializationToConstructor(variablesInside);
	}

	static function processVariableInterpolation( wb:WidgetBuilder, string:String ):{ expr:Expr, variablesInside:Array<String> } {
		var stringAsExpr = Context.makeExpr( string, BuildTools.currentPos() );
		var interpolationExpr = Format.format( stringAsExpr );

		// Get an array of all the variables in interpolationExpr
		var variables:Array<ExtractedVarType> = WidgetMacroUtil.extractVariablesUsedInInterpolation( interpolationExpr );
		var variableNames:Array<String> = [];

		for ( extractedVar in variables )
		{
			switch extractedVar {

				case Ident( varName ):
					var propType = TPath({
						sub: null,
						params: [],
						pack: [],
						name: "String"
					});
					var prop = BuildTools.getOrCreateProperty( wb, varName, propType, false, true );

					var functionName = "print_" + varName;
					if ( BuildTools.fieldExists(functionName) ) {
						// If "print_*" exists, in our interpolationExpr replace calls to $name with print_$name($name)
						var replacements = {};
						Reflect.setField( replacements, varName, macro $i{functionName}() );
						interpolationExpr = interpolationExpr.substitute( replacements );
					}
					if ( variableNames.indexOf(varName)==-1 )
						variableNames.push( varName );

				case Call( varName ), Field( varName ):
					if ( variableNames.indexOf(varName)==-1 )
						variableNames.push( varName );
			}
		}
		if ( variableNames.length>0 ) {
			var nullCheck = BuildTools.generateNullCheckForIdents( variableNames );
			interpolationExpr = macro ( $nullCheck ? $interpolationExpr : "" );
		}

		return {
			expr: interpolationExpr,
			variablesInside: variableNames
		};
	}
}