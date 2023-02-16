package tink.xml.writer;

using StringTools;
//using tink.MacroApi;

abstract OpenTag(String) {
  
  inline function new(s) this = s;
  
  inline function addChildren():TagWithChildren 
    return @:privateAccess new TagWithChildren(this + '>');
  
  public inline function set(name:QName, value:AttributeValue):OpenTag
    return new OpenTag('$this $name="$value"');
  
  @:to inline function close():String
    return '$this/>';
    
  //public inline function close():Parent
    
    
  static public inline function tag(name:QName) {
    return new OpenTag('<$name');
  }
}

abstract AttributeValue(String) to String {
  inline function new(s:String) this = s;
  @:from macro static function ofExpr(e:haxe.macro.Expr) {
    return macro @:pos(e.pos) @:privateAccess new tink.xml.writer.Node.AttributeValue($e);
  }
}

abstract QName(String) to String {
  inline function new(s:String) this = s;
  @:from macro static function ofExpr(e:haxe.macro.Expr) {
    return macro @:pos(e.pos) @:privateAccess new tink.xml.writer.Node.QName($e);
  }  
}

abstract TagWithChildren(String) {
  inline function new(s) this = s;
  
  public function add(child:Child):TagWithChildren
    return new TagWithChildren(this + child.toString());
 
}

abstract Child(String) {
  public inline function new(s:String) this = s;
  public inline function toString() return this;
}