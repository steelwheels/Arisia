interface CollectionIF extends FrameCoreIF {
  collection: string[] ;
  columnNumber: number ;
  frameName: string ;
  pressed(p0: CollectionIF, p1: number, p2: number): void ;
  propertyNames: string[] ;
  totalNumber(): number ;
}
declare function _alloc_Collection(): CollectionIF ;
