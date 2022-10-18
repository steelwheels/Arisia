interface root_FrameIF {
  collection: root_collection_CollectionIF ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
interface root_collection_CollectionIF {
  columnNumber: number ;
  collections: string[] ;
  totalNumber(): number ;
}
