interface root_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  alignment: Alignment ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  icons_table: CollectionIF ;
  logo: ImageIF ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_logo_ImageIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  name: string ;
  propertyNames: string[] ;
  scale: number ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
interface root_icons_table_CollectionIF {
  addObserver(p0: string, p1: () => void): void ;
  collection: string[] ;
  columnNumber: number ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  pressed(p0: root_icons_table_CollectionIF, p1: number, p2: number): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  totalNumber(): number ;
  value(p0: string): any ;
}
