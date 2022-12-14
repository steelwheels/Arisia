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
root._definePropertyType("init0", "f(v,[o(root_BoxIF)])") ;
root._definePropertyType("propertyNames", "a(s)") ;
root._definePropertyType("quit_button", "o(Button)") ;
root._definePropertyType("table", "o(TableData)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["alignment","axis","distribution","frameName","init0","propertyNames","quit_button","table"]) ;
/* assign user declared properties */
root.init0 = function(self: FrameIF): void {
    console.print("index: " + root.table.index     + "\n") ;
    //console.print("c0:    " + root.table.record.c0 + "\n") ;
  };
{
  /* allocate function for frame: TableData */
  let table = _alloc_TableData() as root_table_TableDataIF ;
  /* define type for all properties */
  table._definePropertyType("count", "n") ;
  table._definePropertyType("fieldName", "f(s,[])") ;
  table._definePropertyType("fieldNames", "a(s)") ;
  table._definePropertyType("frameName", "s") ;
  table._definePropertyType("index", "n") ;
  table._definePropertyType("newRecord", "i(RecordIF)") ;
  table._definePropertyType("path", "s") ;
  table._definePropertyType("propertyNames", "a(s)") ;
  table._definePropertyType("record", "i(RecordIF)") ;
  table._definePropertyType("storage", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(table, ["count","fieldName","fieldNames","frameName","index","newRecord","path","propertyNames","record","storage"]) ;
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
        leaveView(1) ;
      };
  root.quit_button = quit_button ;
}
/* Define listner functions */
/* execute initializer methods for frame root */
root.init0(root) ;
/* This value will be return value of evaluateScript() */
root ;
