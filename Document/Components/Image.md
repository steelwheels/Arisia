# `Image` component

## Introduction
Display image which is written in image file such as *.png.

## Interface

This is the interface definition for TypeScript:
<pre>
interface ImageIF {
  name: string ;
  scale: number ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
declare function _alloc_Image(): ImageIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



