"use strict";
/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/home-if.d.ts"/>
/* allocate function for frame: Frame */
let root = _alloc_Frame();
/* define type for all properties */
root.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
root.definePropertyType("alignment", "e(Alignment)");
root.definePropertyType("definePropertyType", "f(v,[s,s])");
root.definePropertyType("frameName", "s");
root.definePropertyType("icons_table", "o(Collection)");
root.definePropertyType("logo", "o(Image)");
root.definePropertyType("propertyNames", "a(s)");
root.definePropertyType("setValue", "f(b,[s,y])");
root.definePropertyType("value", "f(y,[s])");
/* define getter/setter for all properties */
_definePropertyIF(root, ["addObserver", "alignment", "definePropertyType", "frameName", "icons_table", "logo", "propertyNames", "setValue", "value"]);
/* assign user declared properties */
root.alignment = Alignment.center;
{
    /* allocate function for frame: Image */
    let logo = _alloc_Image();
    /* define type for all properties */
    logo.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
    logo.definePropertyType("definePropertyType", "f(v,[s,s])");
    logo.definePropertyType("frameName", "s");
    logo.definePropertyType("name", "s");
    logo.definePropertyType("propertyNames", "a(s)");
    logo.definePropertyType("scale", "n");
    logo.definePropertyType("setValue", "f(b,[s,y])");
    logo.definePropertyType("value", "f(y,[s])");
    /* define getter/setter for all properties */
    _definePropertyIF(logo, ["addObserver", "definePropertyType", "frameName", "name", "propertyNames", "scale", "setValue", "value"]);
    /* assign user declared properties */
    logo.name = "arisia_icon";
    root.logo = logo;
}
{
    /* allocate function for frame: Collection */
    let icons_table = _alloc_Collection();
    /* define type for all properties */
    icons_table.definePropertyType("addObserver", "f(v,[s,f(v,[])])");
    icons_table.definePropertyType("collection", "a(s)");
    icons_table.definePropertyType("columnNumber", "n");
    icons_table.definePropertyType("definePropertyType", "f(v,[s,s])");
    icons_table.definePropertyType("frameName", "s");
    icons_table.definePropertyType("pressed", "f(v,[CollectionIF,n,n])");
    icons_table.definePropertyType("propertyNames", "a(s)");
    icons_table.definePropertyType("setValue", "f(b,[s,y])");
    icons_table.definePropertyType("totalNumber", "f(n,[])");
    icons_table.definePropertyType("value", "f(y,[s])");
    /* define getter/setter for all properties */
    _definePropertyIF(icons_table, ["addObserver", "collection", "columnNumber", "definePropertyType", "frameName", "pressed", "propertyNames", "setValue", "totalNumber", "value"]);
    /* assign user declared properties */
    icons_table.collection = ["run_icon", "pref_icon"];
    icons_table.columnNumber = 3;
    icons_table.pressed = function (self, section, item) {
        var _a;
        switch (item) {
            case 0:
                /* run */
                let url = openPanel("Select application", FileType.file, ["jspkg"]);
                if (url != null) {
                    if (FileManager.isReadable(url)) {
                        console.log("Readable path = " + ((_a = url.path) !== null && _a !== void 0 ? _a : "null"));
                        run(url, [], _stdin, _stdout, _stderr);
                    }
                    else {
                        console.log("Not readable");
                    }
                }
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
