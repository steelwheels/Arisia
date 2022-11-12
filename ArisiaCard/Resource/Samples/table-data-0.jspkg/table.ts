/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/record.d.ts" />
/// <reference path="types/table-if.d.ts" />
/* allocate function for frame: Box */
let root = _alloc_Box() as root_BoxIF ;
/* define type for all properties */
root.definePropertyType("init0", "f(v,[o(root_BoxIF)])") ;
root.definePropertyType("quit_button", "o(Button)") ;
root.definePropertyType("table", "o(TableData)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["init0","quit_button","table"]) ;
/* assign user declared properties */
root.init0 = function(self: FrameIF): void {
	console.print("index: " + root.table.index + "\n") ;
  };
{
  /* allocate function for frame: TableData */
  let table = _alloc_TableData() as root_table_TableDataIF ;
  /* define type for all properties */
  table.definePropertyType("index", "n") ;
  table.definePropertyType("path", "s") ;
  table.definePropertyType("storage", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(table, ["index","path","storage"]) ;
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
  quit_button.definePropertyType("pressed", "f(v,[o(root_quit_button_ButtonIF)])") ;
  quit_button.definePropertyType("title", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(quit_button, ["pressed","title"]) ;
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
