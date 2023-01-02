"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/pref-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("title", "o(Label)");
root._definePropertyType("install", "o(Label)");
root._definePropertyType("install_button", "o(Button)");
root._definePropertyType("buttons", "o(Box)");
root._definePropertyType("axis", "e(Axis)");
root._definePropertyType("frameName", "s");
root._definePropertyType("propertyNames", "a(s)");
root._definePropertyType("distribution", "e(Distribution)");
root._definePropertyType("alignment", "e(Alignment)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "buttons", "distribution", "frameName", "install", "install_button", "propertyNames", "title"]);
{
    /* allocate function for frame: Label */
    let title = _alloc_Label();
    /* define type for all properties */
    title._definePropertyType("text", "s");
    title._definePropertyType("propertyNames", "a(s)");
    title._definePropertyType("frameName", "s");
    title._definePropertyType("number", "n");
    /* define getter/setter for all properties */
    _definePropertyIF(title, ["frameName", "number", "propertyNames", "text"]);
    /* assign user declared properties */
    title.text = "Preference";
    root.title = title;
}
{
    /* allocate function for frame: Label */
    let install = _alloc_Label();
    /* define type for all properties */
    install._definePropertyType("text", "s");
    install._definePropertyType("propertyNames", "a(s)");
    install._definePropertyType("frameName", "s");
    install._definePropertyType("number", "n");
    /* define getter/setter for all properties */
    _definePropertyIF(install, ["frameName", "number", "propertyNames", "text"]);
    /* assign user declared properties */
    install.text = "Install";
    root.install = install;
}
{
    /* allocate function for frame: Button */
    let install_button = _alloc_Button();
    /* define type for all properties */
    install_button._definePropertyType("title", "s");
    install_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
    install_button._definePropertyType("isEnabled", "b");
    install_button._definePropertyType("propertyNames", "a(s)");
    install_button._definePropertyType("frameName", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(install_button, ["frameName", "isEnabled", "pressed", "propertyNames", "title"]);
    /* assign user declared properties */
    install_button.title = "Install sample scripts";
    install_button.pressed = function (self) {
        let resdir = FileManager.resourceDirectory;
        if (resdir != null) {
            let srcdir = resdir.appending("Samples");
            let docdir = FileManager.documentDirectory;
            let dstdir = docdir.appending("Samples");
            if (srcdir != null && dstdir != null) {
                if (!FileManager.copy(srcdir, dstdir)) {
                    console.log("srcdir: " + srcdir.path);
                    console.log("dstdir: " + dstdir.path);
                    console.error("Failed to copy sample directory\n");
                }
            }
        }
        else {
            console.log("no resource directory");
        }
    };
    root.install_button = install_button;
}
{
    /* allocate function for frame: Box */
    let buttons = _alloc_Box();
    /* define type for all properties */
    buttons._definePropertyType("axis", "e(Axis)");
    buttons._definePropertyType("ok_button", "o(Button)");
    buttons._definePropertyType("cancel_button", "o(Button)");
    buttons._definePropertyType("frameName", "s");
    buttons._definePropertyType("propertyNames", "a(s)");
    buttons._definePropertyType("distribution", "e(Distribution)");
    buttons._definePropertyType("alignment", "e(Alignment)");
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
        buttons.ok_button = ok_button;
    }
    {
        /* allocate function for frame: Button */
        let cancel_button = _alloc_Button();
        /* define type for all properties */
        cancel_button._definePropertyType("title", "s");
        cancel_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])");
        cancel_button._definePropertyType("isEnabled", "b");
        cancel_button._definePropertyType("propertyNames", "a(s)");
        cancel_button._definePropertyType("frameName", "s");
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
