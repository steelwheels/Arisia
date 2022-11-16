interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  init0(p0: root_BoxIF): void ;
  propertyNames: string[] ;
  quit_button: ButtonIF ;
  table: TableDataIF ;
}
interface root_table_TableDataIF extends FrameCoreIF {
  count: number ;
  fieldName(): string ;
  fieldNames: string[] ;
  frameName: string ;
  index: number ;
  newRecord: RecordIF ;
  path: string ;
  propertyNames: string[] ;
  record: RecordIF | null ;
  storage: string ;
}
interface root_quit_button_ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: root_quit_button_ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
