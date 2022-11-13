interface LabelIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  number: number ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  text: string ;
  value(p0: string): any ;
}
declare function _alloc_Label(): LabelIF ;
