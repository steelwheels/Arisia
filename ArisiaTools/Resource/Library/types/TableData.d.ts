interface TableDataIF extends FrameIF {
  count: number ;
  fieldName(): string ;
  fieldNames: string[] ;
  index: number ;
  newRecord: RecordIF ;
  path: string ;
  record: RecordIF ;
  storage: string ;
}
declare function _alloc_TableData(): TableDataIF ;
