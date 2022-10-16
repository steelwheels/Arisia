/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/table-0-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("table", "o(TableData)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["table"]) ;
{
  /* allocate function for frame: TableData */
  let table = _alloc_TableData() as root_table_TableDataIF ;
  /* define type for all properties */
  table.definePropertyType("storage", "s") ;
  table.definePropertyType("path", "s") ;
  /* define getter/setter for all properties */
  _definePropertyIF(table, ["storage","path"]) ;
  /* assign user declared properties */
  table.storage = "storage";
  table.path = "root.table";
  root.table = table ;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root ;
