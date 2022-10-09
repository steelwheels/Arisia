"use strict";
/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/main_view-if.d.ts" />
/* allocate function for frame: StackView */
let root = _alloc_StackView();
/* define type for all properties */
root.definePropertyType("button", "o(ButtonView)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["button"]);
{
    /* allocate function for frame: ButtonView */
    let button = _alloc_ButtonView();
    /* define type for all properties */
    button.definePropertyType("title", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(button, ["title"]);
    /* assign user declared properties */
    button.title = "Hello, world !!";
    root.button = button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
