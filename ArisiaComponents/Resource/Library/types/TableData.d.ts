interface TableDataIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  fieldName(): string ;
  frameName: string ;
  newRecord(): { c0:number;
  c1:number;
  c2:number;
   } ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
declare function _alloc_TableData(): TableDataIF ;
