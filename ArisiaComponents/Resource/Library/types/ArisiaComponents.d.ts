interface FrameIF {
  setValue(p0 : string, p1 : any): boolean ;
  frameName : string ;
  propertyNames : string[] ;
  value(p0 : string): any ;
}
interface ButtonViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  title : string ;
  frameName : string ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  isEnabled : boolean ;
}
interface RootViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  distribution : Distribution ;
  frameName : string ;
  axis : Axis ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  alignment : Alignment ;
}
interface StackViewIF {
  setValue(p0 : string, p1 : any): boolean ;
  distribution : Distribution ;
  frameName : string ;
  axis : Axis ;
  propertyNames : string[] ;
  value(p0 : string): any ;
  alignment : Alignment ;
}
