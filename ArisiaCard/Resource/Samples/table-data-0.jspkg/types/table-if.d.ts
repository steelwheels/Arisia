interface root_FrameIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  init0(p0: root_FrameIF): void ;
  propertyNames: string[] ;
  quit_button: ButtonIF ;
  setValue(p0: string, p1: any): boolean ;
  table: TableDataIF ;
  value(p0: string): any ;
}
interface root_table_TableDataIF {
  addObserver(p0: string, p1: () => void): void ;
  count: number ;
  definePropertyType(p0: string, p1: string): void ;
  fieldName(): string ;
  fieldNames: string[] ;
  frameName: string ;
  index: number ;
  newRecord: RecordIF ;
  path: string ;
  propertyNames: string[] ;
  record: RecordIF | null ;
  setValue(p0: string, p1: any): boolean ;
  storage: string ;
  value(p0: string): any ;
}
interface root_quit_button_ButtonIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_quit_button_ButtonIF): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  title: string ;
  value(p0: string): any ;
}
