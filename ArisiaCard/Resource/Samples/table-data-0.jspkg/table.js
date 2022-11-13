"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/record.d.ts"/>
/// <reference path="types/table-if.d.ts"/>
/* allocate function for frame: Frame */
let root = _alloc_Frame();
/* define type for all properties */
root.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
root.definePropertyType("definePropertyType", "f(v,[s,s])");
root.definePropertyType("frameName", "s");
root.definePropertyType("init0", "f(v,[o(root_FrameIF)])");
root.definePropertyType("propertyNames", "a(s)");
root.definePropertyType("quit_button", "o(Button)");
root.definePropertyType("setValue", "f(b,[s,y])");
root.definePropertyType("table", "o(TableData)");
root.definePropertyType("value", "f(y,[s])");
/* define getter/setter for all properties */
_definePropertyIF(root, ["addObserver", "definePropertyType", "frameName", "init0", "propertyNames", "quit_button", "setValue", "table", "value"]);
/* assign user declared properties */
root.init0 = function (self) {
    console.print("index: " + root.table.index + "\n");
    //console.print("c0:    " + root.table.record.c0 + "\n") ;
};
{
    /* allocate function for frame: TableData */
    let table = _alloc_TableData();
    /* define type for all properties */
    table.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
    table.definePropertyType("count", "n");
    table.definePropertyType("definePropertyType", "f(v,[s,s])");
    table.definePropertyType("fieldName", "f(s,[])");
    table.definePropertyType("fieldNames", "a(s)");
    table.definePropertyType("frameName", "s");
    table.definePropertyType("index", "n");
    table.definePropertyType("newRecord", "RecordIF");
    table.definePropertyType("path", "s");
    table.definePropertyType("propertyNames", "a(s)");
    table.definePropertyType("record", "RecordIF | null");
    table.definePropertyType("setValue", "f(b,[s,y])");
    table.definePropertyType("storage", "s");
    table.definePropertyType("value", "f(y,[s])");
    /* define getter/setter for all properties */
    _definePropertyIF(table, ["addObserver", "count", "definePropertyType", "fieldName", "fieldNames", "frameName", "index", "newRecord", "path", "propertyNames", "record", "setValue", "storage", "value"]);
    /* assign user declared properties */
    table.storage = "storage";
    table.path = "root";
    table.index = 0;
    root.table = table;
}
{
    /* allocate function for frame: Button */
    let quit_button = _alloc_Button();
    /* define type for all properties */
    quit_button.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
    quit_button.definePropertyType("definePropertyType", "f(v,[s,s])");
    quit_button.definePropertyType("frameName", "s");
    quit_button.definePropertyType("isEnabled", "b");
    quit_button.definePropertyType("pressed", "f(v,[ButtonIF])");
    quit_button.definePropertyType("propertyNames", "a(s)");
    quit_button.definePropertyType("setValue", "f(b,[s,y])");
    quit_button.definePropertyType("title", "s");
    quit_button.definePropertyType("value", "f(y,[s])");
    /* define getter/setter for all properties */
    _definePropertyIF(quit_button, ["addObserver", "definePropertyType", "frameName", "isEnabled", "pressed", "propertyNames", "setValue", "title", "value"]);
    /* assign user declared properties */
    quit_button.title = "Quit";
    quit_button.pressed = function (self) {
        leaveView(1);
    };
    root.quit_button = quit_button;
}
/* Define listner functions */
/* execute initializer methods for frame root */
root.init0(root);
/* This value will be return value of evaluateScript() */
root;
