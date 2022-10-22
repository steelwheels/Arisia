"use strict";
/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/welcome-if.d.ts" />
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root.definePropertyType("logo", "o(Image)");
root.definePropertyType("ok_button", "o(Button)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["logo", "ok_button"]);
{
    /* allocate function for frame: Image */
    let logo = _alloc_Image();
    /* define type for all properties */
    logo.definePropertyType("name", "s");
    logo.definePropertyType("scale", "n");
    /* define getter/setter for all properties */
    _definePropertyIF(logo, ["name", "scale"]);
    /* assign user declared properties */
    logo.name = "arisia_icon";
    logo.scale = 0.5;
    root.logo = logo;
}
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button.definePropertyType("title", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(ok_button, ["title"]);
    /* assign user declared properties */
    ok_button.title = "OK";
    root.ok_button = ok_button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
