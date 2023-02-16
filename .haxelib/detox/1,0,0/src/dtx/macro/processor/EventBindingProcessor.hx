package dtx.macro.processor;

import dtx.macro.NodeProcessor;
import haxe.ds.Option;
using tink.MacroApi;
using dtx.macro.BuildTools;
using Detox;

/**
	A Processor...
**/
class EventBindingProcessor implements NodeProcessor {
	public function new() {}

	public function process( node:DOMNode, wb:WidgetBuilder ):NodeProcessorResult {
		return NotAffected;
		// return Affected( final, processChildren, Some(replacementNode) );
	}
}