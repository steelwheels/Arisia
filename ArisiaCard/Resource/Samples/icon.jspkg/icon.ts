/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/icon-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box() as root_BoxIF ;
/* define type for all properties */
root._definePropertyType("icon0", "o(Icon)") ;
root._definePropertyType("ok_button", "o(Button)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment","axis","distribution","frameName","icon0","ok_button","propertyNames"]) ;
{
  /* allocate function for frame: Icon */
  let icon0 = _alloc_Icon() as root_icon0_IconIF ;
  /* define type for all properties */
  icon0._definePropertyType("image", "s") ;
  icon0._definePropertyType("image", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(icon0, ["frameName","image","propertyNames","size","symbol","title"]) ;
  /* assign user declared properties */
  icon0.image = "card";
  root.icon0 = icon0 ;
}
{
  /* allocate function for frame: Button */
  let ok_button = _alloc_Button() as root_ok_button_ButtonIF ;
  /* define type for all properties */
  ok_button._definePropertyType("title", "s") ;
  ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])") ;
  ok_button._definePropertyType("title", "s") ;
  ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])") ;
  /* define getter/setter for all properties */
  _definePropertyIF(ok_button, ["frameName","isEnabled","pressed","propertyNames","title"]) ;
  /* assign user declared properties */
  ok_button.title = "OK";
  ok_button.pressed = function(self: FrameIF): void {
  	    	leaveView(0) ;
          };
  root.ok_button = ok_button ;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root ;
