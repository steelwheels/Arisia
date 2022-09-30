interface RootViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  distribution : Distribution ;
  frameName : string ;
  axis : Axis ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  alignment : Alignment ;
}
