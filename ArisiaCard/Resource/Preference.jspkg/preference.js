"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/preference-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("logo", "o(Image)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "distribution", "frameName", "logo", "propertyNames"]);
{
    /* allocate function for frame: Image */
    let logo = _alloc_Image();
    /* define type for all properties */
    logo._definePropertyType("name", "s");
    logo._definePropertyType("name", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(logo, ["frameName", "name", "propertyNames", "scale"]);
    /* assign user declared properties */
    logo.name = "arisia_icon";
    root.logo = logo;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
