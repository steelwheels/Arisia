"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/image-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("img0", "o(Image)");
root._definePropertyType("ok_button", "o(Button)");
root._definePropertyType("axis", "e(Axis)");
root._definePropertyType("propertyNames", "a(s)");
root._definePropertyType("frameName", "s");
root._definePropertyType("alignment", "e(Alignment)");
root._definePropertyType("distribution", "e(Distribution)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "distribution", "frameName", "img0", "ok_button", "propertyNames"]);
{
    /* allocate function for frame: Image */
    let img0 = _alloc_Image();
    /* define type for all properties */
    img0._definePropertyType("name", "s");
    img0._definePropertyType("scale", "n");
    img0._definePropertyType("frameName", "s");
    img0._definePropertyType("propertyNames", "a(s)");
    /* define getter/setter for all properties */
    _definePropertyIF(img0, ["frameName", "name", "propertyNames", "scale"]);
    /* assign user declared properties */
    img0.name = "card";
    img0.scale = 1;
    root.img0 = img0;
}
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
        leaveView(0);
    };
    root.ok_button = ok_button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
