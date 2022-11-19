"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/hello-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("label", "o(Label)");
root._definePropertyType("ok_button", "o(Button)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "distribution", "frameName", "label", "ok_button", "propertyNames"]);
{
    /* allocate function for frame: Label */
    let label = _alloc_Label();
    /* define type for all properties */
    label._definePropertyType("text", "s");
    label._definePropertyType("text", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(label, ["frameName", "number", "propertyNames", "text"]);
    /* assign user declared properties */
    label.text = "Hello, World !!";
    root.label = label;
}
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button._definePropertyType("title", "s");
    ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
    ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
    ok_button._definePropertyType("title", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(ok_button, ["frameName", "isEnabled", "pressed", "propertyNames", "title"]);
    /* assign user declared properties */
    ok_button.title = "OK";
    ok_button.pressed = function (self) {
        leaveView(0);
    };
    root.ok_button = ok_button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
