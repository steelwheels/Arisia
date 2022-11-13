"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/hello-if.d.ts"/>
/* allocate function for frame: Frame */
let root = _alloc_Frame();
/* define type for all properties */
root.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
root.definePropertyType("frameName", "s");
root.definePropertyType("label", "o(Label)");
root.definePropertyType("ok_button", "o(Button)");
root.definePropertyType("propertyNames", "a(s)");
root.definePropertyType("setValue", "f(b,[s,y])");
root.definePropertyType("value", "f(y,[s])");
/* define getter/setter for all properties */
_definePropertyIF(root, ["addObserver", "frameName", "label", "ok_button", "propertyNames", "setValue", "value"]);
{
    /* allocate function for frame: Label */
    let label = _alloc_Label();
    /* define type for all properties */
    label.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
    label.definePropertyType("frameName", "s");
    label.definePropertyType("number", "n");
    label.definePropertyType("propertyNames", "a(s)");
    label.definePropertyType("setValue", "f(b,[s,y])");
    label.definePropertyType("text", "s");
    label.definePropertyType("value", "f(y,[s])");
    /* define getter/setter for all properties */
    _definePropertyIF(label, ["addObserver", "frameName", "number", "propertyNames", "setValue", "text", "value"]);
    /* assign user declared properties */
    label.text = "Hello, World !!";
    root.label = label;
}
{
    /* allocate function for frame: Button */
    let ok_button = _alloc_Button();
    /* define type for all properties */
    ok_button.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
    ok_button.definePropertyType("frameName", "s");
    ok_button.definePropertyType("isEnabled", "b");
    ok_button.definePropertyType("pressed", "f(v,[ButtonIF])");
    ok_button.definePropertyType("propertyNames", "a(s)");
    ok_button.definePropertyType("setValue", "f(b,[s,y])");
    ok_button.definePropertyType("title", "s");
    ok_button.definePropertyType("value", "f(y,[s])");
    /* define getter/setter for all properties */
    _definePropertyIF(ok_button, ["addObserver", "frameName", "isEnabled", "pressed", "propertyNames", "setValue", "title", "value"]);
    /* assign user declared properties */
    ok_button.title = "OK";
    ok_button.pressed = function (self) {
        leaveView(1);
    };
    root.ok_button = ok_button;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
