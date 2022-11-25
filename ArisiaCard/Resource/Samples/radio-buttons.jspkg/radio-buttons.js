"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/radio-buttons-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("buttons", "o(RadioButtons)");
root._definePropertyType("index_listner", "f(v,[o(root_BoxIF),n])");
root._definePropertyType("ok_button", "o(Button)");
root._definePropertyType("propertyNames", "a(s)");
root._definePropertyType("axis", "e(Axis)");
root._definePropertyType("frameName", "s");
root._definePropertyType("alignment", "e(Alignment)");
root._definePropertyType("distribution", "e(Distribution)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "buttons", "distribution", "frameName", "index_listner", "ok_button", "propertyNames"]);
{
    /* allocate function for frame: RadioButtons */
    let buttons = _alloc_RadioButtons();
    /* define type for all properties */
    buttons._definePropertyType("labels", "a(s)");
    buttons._definePropertyType("currentIndex", "n");
    buttons._definePropertyType("frameName", "s");
    buttons._definePropertyType("propertyNames", "a(s)");
    buttons._definePropertyType("columnNum", "n");
    buttons._definePropertyType("setEnable", "f(v,[s,b])");
    /* define getter/setter for all properties */
    _definePropertyIF(buttons, ["columnNum", "currentIndex", "frameName", "labels", "propertyNames", "setEnable"]);
    /* assign user declared properties */
    buttons.labels = ["label-0", "label-1", "label-2"];
    buttons.currentIndex = 0;
    root.buttons = buttons;
}
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button._definePropertyType("title", "s");
    ok_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
    ok_button._definePropertyType("isEnabled", "b");
    ok_button._definePropertyType("propertyNames", "a(s)");
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
let _lfunc_root_index_listner = function (self, idx) {
    console.log("current_index: " + idx);
    return 0;
};
/* add observers for listner function */
root.buttons._addObserver("currentIndex", function () {
    let self = root;
    let idx = root.buttons.currentIndex;
    root.index_listner = _lfunc_root_index_listner(self, idx);
});
/* call listner methods to initialize it's property value for frame root */
root.index_listner = _lfunc_root_index_listner(root, root.buttons.currentIndex);
/* This value will be return value of evaluateScript() */
root;
