"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/home-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box();
/* define type for all properties */
root._definePropertyType("alignment", "e(Alignment)");
root._definePropertyType("logo", "o(Image)");
root._definePropertyType("icons_table", "o(Collection)");
root._definePropertyType("frameName", "s");
root._definePropertyType("axis", "e(Axis)");
root._definePropertyType("distribution", "e(Distribution)");
root._definePropertyType("propertyNames", "a(s)");
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment", "axis", "distribution", "frameName", "icons_table", "logo", "propertyNames"]);
/* assign user declared properties */
root.alignment = Alignment.center;
{
    /* allocate function for frame: Image */
    let logo = _alloc_Image();
    /* define type for all properties */
    logo._definePropertyType("name", "s");
    logo._definePropertyType("scale", "n");
    logo._definePropertyType("propertyNames", "a(s)");
    logo._definePropertyType("frameName", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(logo, ["frameName", "name", "propertyNames", "scale"]);
    /* assign user declared properties */
    logo.name = "arisia_icon";
    root.logo = logo;
}
{
    /* allocate function for frame: Collection */
    let icons_table = _alloc_Collection();
    /* define type for all properties */
    icons_table._definePropertyType("collection", "a(s)");
    icons_table._definePropertyType("columnNumber", "n");
    icons_table._definePropertyType("pressed", "f(v,[i(CollectionIF),n,n])");
    icons_table._definePropertyType("totalNumber", "f(n,[])");
    icons_table._definePropertyType("propertyNames", "a(s)");
    icons_table._definePropertyType("frameName", "s");
    /* define getter/setter for all properties */
    _definePropertyIF(icons_table, ["collection", "columnNumber", "frameName", "pressed", "propertyNames", "totalNumber"]);
    /* assign user declared properties */
    icons_table.collection = ["play", "gearshape"];
    icons_table.columnNumber = 3;
    icons_table.pressed = function (self, section, item) {
        switch (item) {
            case 0:
                /* run */
                let url = openPanel("Select application", FileType.file, ["jspkg"]);
                if (url != null) {
                    if (FileManager.isReadable(url)) {
                        run(url, [], _stdin, _stdout, _stderr);
                    }
                    else {
                        console.log("Not readable");
                    }
                }
                break;
            case 1:
                /* preference */
                enterView("preference", null);
                break;
        }
    };
    root.icons_table = icons_table;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root;
