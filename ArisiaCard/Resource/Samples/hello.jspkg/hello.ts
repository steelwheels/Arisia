/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/hello-if.d.ts" />
/* allocate function for frame: Box */
let root = _alloc_Box() as root_BoxIF ;
/* define type for all properties */
root.definePropertyType("label", "o(Label)") ;
root.definePropertyType("ok_button", "o(Button)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["label","ok_button"]) ;
{
  /* allocate function for frame: Label */
  let label = _alloc_Label() as root_label_LabelIF ;
  /* define type for all properties */
  label.definePropertyType("text", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(label, ["text"]) ;
  /* assign user declared properties */
  label.text = "Hello, World !!";
  root.label = label ;
}
{
  /* allocate function for frame: Button */
  let ok_button = _alloc_Button() as root_ok_button_ButtonIF ;
  /* define type for all properties */
  ok_button.definePropertyType("title", "s") ;
  ok_button.definePropertyType("pressed", "f(v,[o(root_ok_button_ButtonIF)])") ;
  /* define getter/setter for all properties */
  _definePropertyIF(ok_button, ["title","pressed"]) ;
  /* assign user declared properties */
  ok_button.title = "OK";
  ok_button.pressed = function(self: FrameIF): void {
  	    	leaveView(1) ;
          };
  root.ok_button = ok_button ;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root ;
