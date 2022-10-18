/// <reference path="types/ArisiaComponents.d.ts" />
/// <reference path="types/collection-0-if.d.ts" />
/* allocate function for frame: Frame */
let root = _alloc_Frame() as root_FrameIF ;
/* define type for all properties */
root.definePropertyType("collection", "o(Collection)") ;
/* define getter/setter for all properties */
_definePropertyIF(root, ["collection"]) ;
{
  /* allocate function for frame: Collection */
  let collection = _alloc_Collection() as root_collection_CollectionIF ;
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
