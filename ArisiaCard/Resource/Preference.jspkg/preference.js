"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/preference-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("logo", "o(Image)");
root._definePropertyType("buttons", "o(Box)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "buttons", "distribution", "frameName", "logo", "propertyNames"]);
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
{
    /* allocate function for frame: Box */
    let buttons = _alloc_Box();
    /* define type for all properties */
    buttons._definePropertyType("axis", "e(Axis)");
    buttons._definePropertyType("ok_button", "o(Button)");
    buttons._definePropertyType("cancel_button", "o(Button)");
    buttons._definePropertyType("axis", "e(Axis)");
    /* define getter/setter for all properties */
    _definePropertyIF(buttons, ["alignment", "axis", "cancel_button", "distribution", "frameName", "ok_button", "propertyNames"]);
    /* assign user declared properties */
    buttons.axis = Axis.horizontal;
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
        buttons.ok_button = ok_button;
    }
    {
        /* allocate function for frame: Button */
        let cancel_button = _alloc_Button();
        /* define type for all properties */
        cancel_button._definePropertyType("title", "s");
        cancel_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
        cancel_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
        cancel_button._definePropertyType("title", "s");
        /* define getter/setter for all properties */
        _definePropertyIF(cancel_button, ["frameName", "isEnabled", "pressed", "propertyNames", "title"]);
        /* assign user declared properties */
        cancel_button.title = "Cancel";
        cancel_button.pressed = function (self) {
            leaveView(1);
        };
        buttons.cancel_button = cancel_button;
    }
    root.buttons = buttons;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
