interface ImageIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  name: string ;
  propertyNames: string[] ;
  scale: number ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
declare function _alloc_Image(): ImageIF ;
