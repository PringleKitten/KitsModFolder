package dtx.macro;

import haxe.ds.Option;

using Detox;

interface NodeProcessor {
	function process( node:DOMNode, wb:WidgetBuilder ):NodeProcessorResult;
}

/**
	A description of the result of the processor on this node.
**/
enum NodeProcessorResult {
	/** This processor did not have any affect on this node. **/
	NotAffected;

	/**
		This processor did have an affect on this node.

		@param final Should any other processors run on this node?
		@param processChildren Should we continue to process child nodes?
		@param replacementNode (optional) Replace this node in the template.
			If `replacementNode==null`, no replacement is made.
			If `replacementNode==None`, the node is removed from the template, and `final` and `processChildren` are set to false.
	**/
	Affected( final:Bool, processChildren:Bool, ?replacementNode:Option<DOMNode> );
}