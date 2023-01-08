"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/google-search-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("title_label", "o(Label)");
root._definePropertyType("ok_button", "o(Button)");
root._definePropertyType("distribution", "e(Distribution)");
root._definePropertyType("alignment", "e(Alignment)");
root._definePropertyType("axis", "e(Axis)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "distribution", "ok_button", "title_label"]);
{
    /* allocate function for frame: Label */
    let title_label = _alloc_Label();
    /* define type for all properties */
    title_label._definePropertyType("text", "s");
    title_label._definePropertyType("number", "n");
    /* define getter/setter for all properties */
    _definePropertyIF(title_label, ["number", "text"]);
    /* assign user declared properties */
    title_label.text = "Google Search Helper";
    root.title_label = title_label;
}
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button._definePropertyType("title", "s");
    ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
    ok_button._definePropertyType("isEnabled", "b");
    /* define getter/setter for all properties */
    _definePropertyIF(ok_button, ["isEnabled", "pressed", "title"]);
    /* assign user declared properties */
    ok_button.title = "OK";
    ok_button.pressed = function (self) {
        openURL("https://www.google.com/");
    };
    root.ok_button = ok_button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
