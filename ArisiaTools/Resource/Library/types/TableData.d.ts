interface TableDataIF extends FrameIF {
  count: number ;
  fieldName(p0: string): string ;
  fieldNames: string[] ;
  newRecord(): RecordIF ;
  record(p0: number): RecordIF ;
  save(): boolean ;
  toString(): string ;
}
declare function _alloc_TableData(): TableDataIF ;
