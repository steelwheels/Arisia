"use strict";
/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/hello-if.d.ts" />
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root.definePropertyType("ok_button", "o(Button)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["ok_button"]);
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button.definePropertyType("title", "s");
    ok_button.definePropertyType("pressed", "f(v,[o(root_ok_button_ButtonIF)])");
    /* define getter/setter for all properties */
    _definePropertyIF(ok_button, ["title", "pressed"]);
    /* assign user declared properties */
    ok_button.title = "OK";
    ok_button.pressed = function (self) {
        console.log("pressed: OK");
        leaveView(1);
    };
    root.ok_button = ok_button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
