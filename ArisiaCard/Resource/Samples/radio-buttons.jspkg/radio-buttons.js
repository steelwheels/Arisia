"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/radio-buttons-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("rad", "o(RadioButtons)");
root._definePropertyType("ok_button", "o(Button)");
root._definePropertyType("propertyNames", "a(s)");
root._definePropertyType("alignment", "e(Alignment)");
root._definePropertyType("axis", "e(Axis)");
root._definePropertyType("distribution", "e(Distribution)");
root._definePropertyType("frameName", "s");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "distribution", "frameName", "ok_button", "propertyNames", "rad"]);
{
    /* allocate function for frame: RadioButtons */
    let rad = _alloc_RadioButtons();
    /* define type for all properties */
    rad._definePropertyType("labels", "a(s)");
    rad._definePropertyType("columnNum", "n");
    rad._definePropertyType("currentIndex", "n");
    rad._definePropertyType("propertyNames", "a(s)");
    rad._definePropertyType("setEnable", "f(v,[s,b])");
    rad._definePropertyType("frameName", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(rad, ["columnNum", "currentIndex", "frameName", "labels", "propertyNames", "setEnable"]);
    /* assign user declared properties */
    rad.labels = ["label-0", "label-1", "label-2"];
    root.rad = rad;
}
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button._definePropertyType("title", "s");
    ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
    ok_button._definePropertyType("propertyNames", "a(s)");
    ok_button._definePropertyType("isEnabled", "b");
    ok_button._definePropertyType("frameName", "s");
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
