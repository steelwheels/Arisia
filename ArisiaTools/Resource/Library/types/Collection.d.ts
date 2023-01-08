interface CollectionIF extends FrameIF {
  collection: string[] ;
  columnNumber: number ;
  pressed(p0: CollectionIF, p1: number, p2: number): void ;
  totalNumber(): number ;
}
declare function _alloc_Collection(): CollectionIF ;
