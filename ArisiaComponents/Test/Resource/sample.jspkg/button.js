"use strict";
/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/button-if.d.ts" />
/* allocate function for frame: StackView */
let root = _alloc_StackView();
/* define type for all properties */
root.definePropertyType("top", "o(StackView)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["top"]);
{
    /* allocate function for frame: StackView */
    let top = _alloc_StackView();
    /* define type for all properties */
    top.definePropertyType("button_a", "o(ButtonView)");
    /* define getter/setter for all properties */
    _definePropertyIF(top, ["button_a"]);
    {
        /* allocate function for frame: ButtonView */
        let button_a = _alloc_ButtonView();
        /* define type for all properties */
        button_a.definePropertyType("title", "s");
        button_a.definePropertyType("pressed", "f(v,[o(root_top_button_a_ButtonViewIF)])");
        /* define getter/setter for all properties */
        _definePropertyIF(button_a, ["title", "pressed"]);
        /* assign user declared properties */
        button_a.title = "Back to First";
        button_a.pressed = function (self) {
            console.log("leave view");
            leaveView(1234);
        };
        top.button_a = button_a;
    }
    root.top = top;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
