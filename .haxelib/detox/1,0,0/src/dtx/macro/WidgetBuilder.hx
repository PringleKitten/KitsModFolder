package dtx.macro;

import haxe.macro.Context;
import tink.macro.ClassBuilder;
import tink.macro.Member;
import haxe.macro.Type;
import haxe.macro.Expr;
import dtx.macro.processor.*;
using tink.MacroApi;
using dtx.macro.BuildTools;
using Detox;

class WidgetBuilder extends ClassBuilder {

	/** The name of this class (not including package) **/
	public var name(default,null):String;

	/** The name of this class (including package) **/
	public var qualifiedName(default,null):String;

	/** The `haxe.macro.Type` of the current widget class **/
	public var targetType(default,null):Type;

	/** The `haxe.macro.ComplexType` of the current widget class **/
	public var targetComplexType(default,null):ComplexType;

	/** The template used for this widget **/
	public var template(default,null):WidgetTemplate;

	/** The counter for the number of loops in this widget, used to generate unique names. **/
	public var loopCounter:Int;

	/** The counter for the number of partial declarations in this widget, used to generate unique names. **/
	public var partialCounter:Int;

	/** The counter for the number of named nodes in this widget, used to generate unique names **/
	public var selectorCounter:Int;

	public var initFn(default,null):Member;
	public var getTemplateFn(default,null):Member;

	/** Create a new WidgetBuilder **/
	public function new() {
		super();
		selectorCounter = 0;
		loopCounter = 0;
		partialCounter = 0;
		this.qualifiedName = Context.getLocalClass().toString();
		this.name = qualifiedName.split(".").pop();
		this.targetType = Context.getLocalType();
		this.targetComplexType = Context.toComplexType( targetType );
	}

	/**
		Load the template
	**/
	public function loadTemplate() {
		this.template = WidgetTemplate.getTemplate( qualifiedName, this ).sure();
		switch template.source {
			case TemplateNotFound( name ):
				error( 'Could not load the widget template: $name' );
			default:
		}
	}

	/**
		If a template has been found, add the `init()` methods.
	**/
	public function addInit() {
		this.initFn = BuildTools.getOrCreateField( this, {
			pos: BuildTools.currentPos(),
			name: "init",
			meta: [],
			kind: FieldType.FFun({
					ret: null,
					params: [],
					expr: macro {},
					args: []
				}),
			doc: "",
			access: [APrivate,AOverride]
		});
	}

	/**
		If a template has been found, add `init()` and `get_template()` methods.
	**/
	public function addGetTemplate() {
		this.getTemplateFn = BuildTools.getOrCreateField( this, {
			name : "get_template",
			doc : '__Template__:\n\n```\n${template.originalHtml}\n```',
			meta : [],
			access : [APublic,AOverride],
			kind : FFun({
				args: [],
				expr: macro { return $v{template.templateHtml}; },
				params: [],
				ret: null
			}),
			pos: this.target.pos
		});
	}

	/**
		Process each node in a DOMCollection using our `NodeProcessor` plugins.
	**/
	public function processNodes( ?nodes:DOMCollection ) {

		if ( nodes==null )
			nodes = template.collection;

		for ( node in nodes ) {
			var processChildren = true;
			for ( np in nodeProcessors ) {

				switch np.process( node, this ) {

					case Affected( final, doChildren, replacementNode ):

						if ( replacementNode!=null ) switch replacementNode {
							case Some( newNode ):
								node.replaceWith( newNode );
								node = newNode;
							case None:
								node.removeFromDOM();
								processChildren = false;
								final = true;
						}

						if ( doChildren==false )
							processChildren = false;
						if ( final )
							break;

					case NotAffected:
				}

			}
			if ( processChildren )
				processNodes( node.children(false) );
		}
	}

	/**
		Perform a `Context.fatalError` at this class position.
	**/
	public function error( msg:String, ?pos:Position ) {
		if ( pos==null )
			pos = target.pos;

		Context.fatalError( msg, target.pos );
	}

	/**
		Perform a `Context.warning` at this class position.
	**/
	public function warning( msg:String, ?pos:Position ) {
		if ( pos==null )
			pos = target.pos;

		Context.warning( msg, target.pos );
	}

	/**
		Return an expression used to reference the given node.
		In practice this is not a CSS style selector, rather, all nodes are given a data-attribute, and this is used to add named nodes to a special array.
		The returned expression is then in the form of: `_dtxWidgetNodeIndex[1]:DOMNode`
	**/
	public function getUniqueSelectorForNode( node:DOMNode ):Expr {
		var id = node.attr("data-dtx-id");
		if ( id=="" ) {
			selectorCounter++;
			id = ''+selectorCounter;
			node.setAttr( "data-dtx-id", id );
		}
		return macro _dtxWidgetNodeIndex[$v{selectorCounter}];
	}

	/**
		Add an expression to the setters of all of the listed variables.

		If no variables are specified, the expression will be added to the initFn.
	**/
	public function addExprToAllSetters( expr:Expr, variables:Array<String>, ?whereToAdd=-1 ) {
		if ( variables.length==0 ) {
			// Add it to the init() function instead of setters.
			BuildTools.addLinesToFunction( initFn, expr, whereToAdd );
		}
		else for ( varName in variables ) {
			if ( !varName.fieldExists() )
				error( 'Field $varName not found in $qualifiedName' );

			varName.getField().getSetter( this ).addLinesToFunction( expr, whereToAdd );
		}
	}

	/**
		Adds an initialization value for certain fields to the constructor.

		This ensure that fields have appropriate values by the time `init()` is called, and before any variable substitution etc.

		The following initializations are made:

		- Int: 0
		- Float: 0
		- String: ""
		- Bool: false
		- other: null
	**/
	public function addMemberInitializationToConstructor( fieldNames:Array<String> ) {
		for ( fieldName in fieldNames ) {
			var field = fieldName.getField();
			switch field.kind {
				case FProp(get,set,type,e):
					var initValueExpr:Expr = null;

					if ( e!=null ) {
						initValueExpr = e;
					}
					else {
						if ( type==null )
							error( 'Unknown type when trying to initialize $fieldName on widget $qualifiedName' );

						switch type {
							case TPath(path):
								var name = path.name;

								if ( name=="StdTypes" )
									name = path.sub;

								initValueExpr = switch name {
									case "Bool": macro false;
									case "String": macro "";
									case "Int": macro 0;
									case "Float": macro 0.0;
									default: macro null;
								}
							default:
						}
					}

					if ( initValueExpr!=null ) {
						// Update the init expression, and add to the init function
						// We want both, the init function so that setters fire and update the DOM,
						// and the init expression so that all values are initialized by the time the first setter fires also...
						field.kind = FProp( get,set,type,initValueExpr );
						var varRef = fieldName.resolve();
						var setExpr = macro $varRef = $initValueExpr;
						BuildTools.addLinesToFunction( initFn, setExpr );
					}
				default:
			}
		}
	}

	/**
		The various processors we are using on our template.
	**/
	public static var nodeProcessors:Array<NodeProcessor> = [
		new PartialDeclarationProcessor(),
		new PartialCallProcessor(),
		new LoopCallProcessor(),
		new BoolAttributeProcessor(),
		new NamedPropertyProcessor(),
		new EventBindingProcessor(),
		new ValueBindingProcessor(),
		new SetContentProcessor(),
		new InterpolationProcessor(),
		new TrimWhitespaceProcessor(),
	];

	/**
		Create the `WidgetBuilder` class, load the template, process it, and add fields as required.
	**/
	public static function buildWidget() {
		var wb = new WidgetBuilder();

		wb.loadTemplate();
		if ( wb.template.templateFound ) {
			wb.addInit();
			wb.processNodes();
			wb.addGetTemplate();
			return wb.export();
		}
		else return null;

	}
}