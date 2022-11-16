interface TableDataIF extends FrameCoreIF {
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
declare function _alloc_TableData(): TableDataIF ;
