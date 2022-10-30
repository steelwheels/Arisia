"use strict";
/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/welcome-if.d.ts" />
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root.definePropertyType("alignment", "e(Alignment)");
root.definePropertyType("logo", "o(Image)");
root.definePropertyType("icons_table", "o(Collection)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "logo", "icons_table"]);
/* assign user declared properties */
root.alignment = Alignment.center;
{
    /* allocate function for frame: Image */
    let logo = _alloc_Image();
    /* define type for all properties */
    logo.definePropertyType("name", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(logo, ["name"]);
    /* assign user declared properties */
    logo.name = "arisia_icon";
    root.logo = logo;
}
{
    /* allocate function for frame: Collection */
    let icons_table = _alloc_Collection();
    /* define type for all properties */
    icons_table.definePropertyType("collection", "a(s)");
    icons_table.definePropertyType("columnNumber", "n");
    icons_table.definePropertyType("pressed", "f(v,[o(root_icons_table_CollectionIF),n,n])");
    /* define getter/setter for all properties */
    _definePropertyIF(icons_table, ["collection", "columnNumber", "pressed"]);
    /* assign user declared properties */
    icons_table.collection = ["run_icon", "pref_icon"];
    icons_table.columnNumber = 3;
    icons_table.pressed = function (self, section, item) {
        switch (item) {
            case 0:
                /* run */
                let url = openPanel("Select application", FileType.directory, ["jspkg"]);
                break;
            case 1:
                /* preference */
                break;
        }
    };
    root.icons_table = icons_table;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
