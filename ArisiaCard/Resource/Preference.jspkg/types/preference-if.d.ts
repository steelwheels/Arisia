interface root_BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  logo: ImageIF ;
  propertyNames: string[] ;
}
interface root_logo_ImageIF extends FrameCoreIF {
  frameName: string ;
  name: string ;
  propertyNames: string[] ;
  scale: number ;
}
