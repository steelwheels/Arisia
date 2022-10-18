/* allocate function for frame: Frame */
let root = _alloc_Frame()  ;
/* define type for all properties */
root.definePropertyType("collection", "o(Collection)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["collection"]) ;
{
  /* allocate function for frame: Collection */
  let collection = _alloc_Collection()  ;
  /* define type for all properties */
  collection.definePropertyType("columnNumber", "n") ;
  collection.definePropertyType("collections", "a(s)") ;
  /* define getter/setter for all properties */
  _definePropertyIF(collection, ["columnNumber","collections"]) ;
  /* assign user declared properties */
  collection.columnNumber = 3;
  collection.collections = ["a", "b", "c"];
  root.collection = collection ;
}
/* Define listner functions */
/* This value will be return value of evaluateScript() */
root ;
