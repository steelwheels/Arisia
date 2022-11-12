interface root_BoxIF {
  init0(p0: root_BoxIF): void ;
  quit_button: root_quit_button_ButtonIF ;
  table: root_table_TableDataIF ;
  axis: Axis ;
  alignment: Alignment ;
  distribution: Distribution ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
interface root_quit_button_ButtonIF {
  pressed(p0: root_quit_button_ButtonIF): void ;
  title: string ;
  isEnabled: boolean ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
interface root_table_TableDataIF {
  index: number ;
  path: string ;
  storage: string ;
  count: number ;
  fieldNames: string[] ;
  fieldName(): string ;
  newRecord: storage_root_RecordIF ;
  record: storage_root_RecordIF | null ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
