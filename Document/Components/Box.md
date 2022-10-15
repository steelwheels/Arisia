# `Box` component

## Introduction
The box to pack some components.
They will be layouted holizontally or vertically.

## Interface

This is the interface definition for TypeScript:
<pre>
interface BoxIF {
  addObserver(p0: string, p1: () => void): void ;
  alignment: Alignment ;
  axis: Axis ;
  definePropertyType(p0: string, p1: string): void ;
  distribution: Distribution ;
  frameName: string ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  value(p0: string): any ;
}
declare function _alloc_Box(): BoxIF ;

</pre>
