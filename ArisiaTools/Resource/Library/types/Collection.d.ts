interface CollectionIF {
  addObserver(p0: string, p1: () => void): void ;
  collection: string[] ;
  columnNumber: number ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  pressed(p0: CollectionIF, p1: number, p2: number): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  totalNumber(): number ;
  value(p0: string): any ;
}
declare function _alloc_Collection(): CollectionIF ;
