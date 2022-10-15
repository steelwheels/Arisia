"use strict";
/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/main_view-if.d.ts" />
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root.definePropertyType("button", "o(Button)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["button"]);
{
    /* allocate function for frame: Button */
    let button = _alloc_Button();
    /* define type for all properties */
    button.definePropertyType("title", "s");
    button.definePropertyType("pressed", "f(v,[o(root_button_ButtonIF)])");
    /* define getter/setter for all properties */
    _definePropertyIF(button, ["title", "pressed"]);
    /* assign user declared properties */
    button.title = "Hello, world !!";
    button.pressed = function (self) {
        console.log("Pressed");
    };
    root.button = button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
