package dtx.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
using dtx.macro.BuildTools;
using tink.MacroApi;
using tink.CoreApi;
using Detox;
using StringTools;

/**
	A `WidgetTemplate` describes the template for a given widget and is used while building the widget's class.

	Use `getTemplate` to find the template for a given class.
**/
class WidgetTemplate {

	static var cachedTemplates:Map<String,WidgetTemplate>;
	/**
		Fetch a template from an already built widget.

		If it has not been built yet, and `wb` is supplied, it will build the
		If it has not been built yet, it will force it to be built by calling Context.getType()
	**/
	public static function getTemplate( typeName:String, ?wb:WidgetBuilder ):Outcome<WidgetTemplate,Error> {

		if ( cachedTemplates==null )
			cachedTemplates = new Map();

		if ( wb!=null ) {
			// We are being called from the widget's build macro, so fetch it
			cachedTemplates[typeName] = new WidgetTemplate( wb );
		}
		else if ( cachedTemplates[typeName]==null ) {
			var type = Context.getType(typeName);
			if ( type==null )
				return Failure( new Error('Failed to find widget $typeName', wb.target.pos) );
		}

		var tpl = cachedTemplates[typeName];
		return
			if ( tpl!=null ) Success( tpl );
			else Failure( new Error('Failed to load template.',wb.target.pos) );
	}

	/** The original HTML used in the template **/
	public var originalHtml(default,null):String;

	/**
		Was a template found, do we need to process it?

		Essentially this is a shortcut for `originalHtml!=null`
	**/
	public var templateFound(get,null):Bool;

	/** The collection of parsed nodes for this template **/
	public var collection(default,null):DOMCollection;

	/**
		The HTML after processing has occurred, to be used in the `get_template` function.

		This is a shortcut for `collection.html()`
	**/
	public var templateHtml(get,null):String;

	/** The source of the template **/
	public var source(default,null):TemplateSource;

	/**
		The HTML for any inline partial declarations found in this widget.

		This is available so that when the Widget for the partial is being built, it can look to the parent WidgetTemplate to know it's own template.
	**/
	public var partialTemplates(default,null):Map<String,String>;

	/**
		The HTML for any inline-loop templates found in this widget.

		This is available so that when the Widget for the loop item is being built, it can look to the parent WidgetTemplate to know it's own template.
	**/
	public var loopTemplates(default,null):Map<String,String>;

	/** The WidgetBuilder this template belongs to **/
	var wb:WidgetBuilder;

	function new( wb:WidgetBuilder ) {
		this.loopTemplates = new Map();
		this.partialTemplates = new Map();
		this.wb = wb;
		findTemplate();
		loadTemplate();
		parseTemplate();
	}

	inline function get_templateHtml() return collection.html();
	inline function get_templateFound() return originalHtml!=null;

	//
	// Functions to locate, load and parse templates
	//

	/**
		Locate the source of the template by looking at metadata, related files, parent classes etc.
	**/
	function findTemplate() {

		var hasMetadataForNoTemplate = BuildTools.hasClassMetadata(":noTemplate");
		var hasGetTemplateFn = wb.hasOwnMember("get_template");
		var hasTemplateMetadata = BuildTools.hasClassMetadata(":template");
		var hasTemplateFileMetadata = BuildTools.hasClassMetadata(":templateFile");
		var parentHasTemplateMetadata = BuildTools.hasClassMetadata(":template", true);
		var parentHasTemplateFileMetadata = BuildTools.hasClassMetadata(":template", true);

		var inferredFileName = wb.name+".html";
		// TODO: Use a simple FileSystem.exists, rather than reading the content.
		// We would have to check both the qualified name and the name relative to the current class.
		var inferredFileContents = BuildTools.loadFileFromLocalContext( inferredFileName );

		// TODO: Split these up so the actual READING doesn't occur here, but later.

		if ( hasMetadataForNoTemplate ) {
			this.source = NoTemplate;
		}
		else if ( hasGetTemplateFn ) {
			this.source = HasGetTemplateMethod;
		}
		else if ( hasTemplateMetadata ) {
			this.source = TemplateMetadata;
		}
		else if ( hasTemplateFileMetadata ) {
			var fileName = BuildTools.getClassMetadata_String(":templateFile", false);
			this.source = File( fileName );
		}
		else if ( inferredFileContents!=null ) {
			this.source = File( inferredFileName );
		}
		else if ( parentHasTemplateMetadata || parentHasTemplateFileMetadata ) {
			this.source = ParentHasTemplate;
		}
		else {
			var isPartial = false;
			var isLoop = false;

			var nameParts = wb.name.split("_");
			var lastPart = nameParts[ nameParts.length-1 ];
			var secondLastPart = nameParts[ nameParts.length-2 ];
			if ( nameParts.length>2 && secondLastPart=="loop" ) {

				// name wrangling
				nameParts.pop();
				nameParts.pop();
				var parentName = nameParts.join( "_" );
				var parentQualifiedNameParts = wb.qualifiedName.split( "." );
				parentQualifiedNameParts.pop();
				parentQualifiedNameParts.push( parentName );
				var parentQualifiedName = parentQualifiedNameParts.join(".");
				var loopName = lastPart;

				// get the parent template, load our partial template
				this.source = LoopPartial( parentQualifiedName, loopName );
			}
			else if ( nameParts.length>1 ) {

				// name wrangling
				nameParts.pop();
				var parentName = nameParts.join( "_" );
				var parentQualifiedNameParts = wb.qualifiedName.split( "." );
				parentQualifiedNameParts.pop();
				parentQualifiedNameParts.push( parentName );
				var parentQualifiedName = parentQualifiedNameParts.join(".");
				var partialName = lastPart;

				// get the parent template, load our partial template
				this.source = Partial( parentQualifiedName, partialName );

			}
			if ( this.source==null ) {
				this.source = TemplateNotFound( inferredFileName );
			}
		}
	}

	/**
		Given a source for the template, load the template into `originalHtml`
	**/
	function loadTemplate() {
		switch this.source {
			case TemplateNotFound( name ):
				Context.fatalError( 'Widget template not found (tried $name)', wb.target.pos );
			case NoTemplate:
			case ParentHasTemplate:
			case HasGetTemplateMethod:
			case TemplateMetadata:
				this.originalHtml = BuildTools.getClassMetadata_String(":template", false);
			case File( name ):
				this.originalHtml = BuildTools.loadFileFromLocalContext( name );
			case Partial( parentName, name ):
				var parentTemplate = getTemplate( parentName ).sure();
				if ( parentTemplate.partialTemplates.exists(name) )
					this.originalHtml = parentTemplate.partialTemplates[name];
				else
					Context.fatalError( 'Partial template $name was not found in parent template $parentName (${parentTemplate.source})', wb.target.pos );
			case LoopPartial( parentName, loopName ):
				var parentTemplate = getTemplate( parentName ).sure();
				if ( parentTemplate.loopTemplates.exists(loopName) )
					this.originalHtml = parentTemplate.loopTemplates[loopName];
				else
					Context.fatalError( 'Loop template $loopName was not found in parent template $parentName (${parentTemplate.source})', wb.target.pos );
		}

		trace( 'For ${wb.name}:\n  Source: $source\n  HTML: $originalHtml' );
	}

	/**
		Given a template that has been loaded, parse it into a DOMCollection.
	**/
	function parseTemplate() {
		if ( this.templateFound ) {
			this.collection = originalHtml.parse();
			if ( this.collection.length==0 ) {
				Context.fatalError( 'Failed to parse template for ${wb.name} (from $source)', wb.target.pos );
			}
		}
	}
}

enum TemplateSource {
	TemplateNotFound( name:String );
	NoTemplate;
	ParentHasTemplate;
	HasGetTemplateMethod;
	TemplateMetadata;
	File( name:String );
	Partial( qualifiedParentName:String, name:String );
	LoopPartial( qualifiedParentName:String, loopName:String );
}