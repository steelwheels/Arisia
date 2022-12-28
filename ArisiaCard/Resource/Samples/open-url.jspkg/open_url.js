"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/open_url-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("ok_button", "o(Button)");
root._definePropertyType("propertyNames", "a(s)");
root._definePropertyType("distribution", "e(Distribution)");
root._definePropertyType("alignment", "e(Alignment)");
root._definePropertyType("axis", "e(Axis)");
root._definePropertyType("frameName", "s");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "distribution", "frameName", "ok_button", "propertyNames"]);
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button._definePropertyType("title", "s");
    ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
    ok_button._definePropertyType("frameName", "s");
    ok_button._definePropertyType("isEnabled", "b");
    ok_button._definePropertyType("propertyNames", "a(s)");
    /* define getter/setter for all properties */
    _definePropertyIF(ok_button, ["frameName", "isEnabled", "pressed", "propertyNames", "title"]);
    /* assign user declared properties */
    ok_button.title = "OK";
    ok_button.pressed = function (self) {
        if (openURL("https://www.google.com/")) {
            leaveView(0); // No error
        }
        else {
            leaveView(1); // Some error
        }
    };
    root.ok_button = ok_button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
