/* allocate function for frame: Frame */
let root = _alloc_Frame()  ;
/* define type for all properties */
root.definePropertyType("table", "o(TableData)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["table"]) ;
{
  /* allocate function for frame: TableData */
  let table = _alloc_TableData()  ;
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
