package dtx.macro.processor;

import dtx.macro.NodeProcessor;
import haxe.ds.Option;
import haxe.macro.Expr;
import haxe.macro.Type;
using tink.MacroApi;
using dtx.macro.BuildTools;
using Detox;

/**
	A Processor...
**/
class NamedPropertyProcessor implements NodeProcessor {
	public function new() {}

	public function process( node:DOMNode, wb:WidgetBuilder ):NodeProcessorResult {
		var name = node.attr( "dtx-name" );
		if ( name!="" ) {

			var selector = wb.getUniqueSelectorForNode( node );

			var propType = TPath({
				sub: null,
				params: [],
				pack: ['dtx'],
				name: "DOMNode"
			});
			var prop = BuildTools.getOrCreateProperty( wb, name, propType, true, false );

			// Change the setter to null so it is read only.
			switch prop.property.kind {
				case FieldType.FProp( get, _, t, e ):
					prop.property.kind = FieldType.FProp( get, "null", t, e );
				default:
			}

			// Change the getter to null
			switch prop.getter.kind {
				case FFun( f ):
					f.expr = macro return $selector;
					prop.getter.access.push( AInline );
				default:
			}

			return Affected( false, true );
		}
		else return NotAffected;
	}
}