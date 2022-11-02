interface root_BoxIF {
  alignment: Alignment ;
  logo: root_logo_ImageIF ;
  icons_table: root_icons_table_CollectionIF ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
interface root_logo_ImageIF {
  name: string ;
  scale: number ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
interface root_icons_table_CollectionIF {
  collection: string[] ;
  columnNumber: number ;
  pressed(p0: root_icons_table_CollectionIF, p1: number, p2: number): void ;
  totalNumber(): number ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
