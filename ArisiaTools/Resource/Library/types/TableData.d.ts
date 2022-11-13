interface TableDataIF {
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
declare function _alloc_TableData(): TableDataIF ;
