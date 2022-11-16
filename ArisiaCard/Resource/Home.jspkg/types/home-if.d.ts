interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  icons_table: CollectionIF ;
  logo: ImageIF ;
  propertyNames: string[] ;
}
interface root_logo_ImageIF extends FrameCoreIF {
  frameName: string ;
  name: string ;
  propertyNames: string[] ;
  scale: number ;
}
interface root_icons_table_CollectionIF extends FrameCoreIF {
  collection: string[] ;
  columnNumber: number ;
  frameName: string ;
  pressed(p0: root_icons_table_CollectionIF, p1: number, p2: number): void ;
  propertyNames: string[] ;
  totalNumber(): number ;
}
