/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/main_view-if.d.ts" />
/* allocate function for frame: StackView */
let root = _alloc_StackView() as root_StackViewIF ;
/* define type for all properties */
root.definePropertyType("button", "o(ButtonView)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["button"]) ;
{
  /* allocate function for frame: ButtonView */
  let button = _alloc_ButtonView() as root_button_ButtonViewIF ;
  /* define type for all properties */
  button.definePropertyType("title", "s") ;
  button.definePropertyType("pressed", "f(v,[o(root_button_ButtonViewIF)])") ;
  /* define getter/setter for all properties */
  _definePropertyIF(button, ["title","pressed"]) ;
  /* assign user declared properties */
  button.title = "Hello, world !!";
  button.pressed = function(self: FrameIF): void {
        console.log("Pressed") ;
      };
  root.button = button ;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root ;
