/// <reference path="types/ArisiaPlatform.d.ts"/>
/// <reference path="types/record.d.ts"/>
/// <reference path="types/table-if.d.ts"/>
/* allocate function for frame: Box */
let root = _alloc_Box() as root_BoxIF ;
/* define type for all properties */
root._definePropertyType("alignment", "e(Alignment)") ;
root._definePropertyType("axis", "e(Axis)") ;
root._definePropertyType("distribution", "e(Distribution)") ;
root._definePropertyType("frameName", "s") ;
root._definePropertyType("propertyNames", "a(s)") ;
root._definePropertyType("quit_button", "o(Button)") ;
root._definePropertyType("table", "o(TableData)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment","axis","distribution","frameName","propertyNames","quit_button","table"]) ;
{
  /* allocate function for frame: TableData */
  let table = _alloc_TableData() as root_table_TableDataIF ;
  /* define type for all properties */
  table._definePropertyType("count", "n") ;
  table._definePropertyType("fieldName", "f(s,[s])") ;
  table._definePropertyType("fieldNames", "a(s)") ;
  table._definePropertyType("index", "n") ;
  table._definePropertyType("newRecord", "f(i(RecordIF),[])") ;
  table._definePropertyType("path", "s") ;
  table._definePropertyType("record", "f(i(RecordIF),[n])") ;
  table._definePropertyType("save", "f(b,[])") ;
  table._definePropertyType("storage", "s") ;
  table._definePropertyType("toString", "f(s,[])") ;
  /* define getter/setter for all properties */
  _definePropertyIF(table, ["count","fieldName","fieldNames","index","newRecord","path","record","save","storage","toString"]) ;
  /* assign user declared properties */
  table.storage = "storage";
  table.path = "root";
  table.index = 0;
  root.table = table ;
}
{
  /* allocate function for frame: Button */
  let quit_button = _alloc_Button() as root_quit_button_ButtonIF ;
  /* define type for all properties */
  quit_button._definePropertyType("frameName", "s") ;
  quit_button._definePropertyType("isEnabled", "b") ;
  quit_button._definePropertyType("pressed", "f(v,[i(ButtonIF)])") ;
  quit_button._definePropertyType("propertyNames", "a(s)") ;
  quit_button._definePropertyType("title", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(quit_button, ["frameName","isEnabled","pressed","propertyNames","title"]) ;
  /* assign user declared properties */
  quit_button.title = "Quit";
  quit_button.pressed = function(self: FrameIF): void {
        console.print("count: " + root.table.count + "\n") ;
        //console.print("c0:    " + root.table.record(0).c0 + "\n") ;
        leaveView(1) ;
      };
  root.quit_button = quit_button ;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root ;
