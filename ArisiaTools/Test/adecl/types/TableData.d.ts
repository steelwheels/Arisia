interface TableDataIF {
  fieldName(): string ;
  newRecord(): { c0:number;
  c1:number;
  c2:number;
   } ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
declare function _alloc_TableData(): TableDataIF ;
