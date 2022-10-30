# `Box` component

## Introduction
The box to pack some components.
They will be layouted holizontally or vertically.

## Interface

This is the interface definition for TypeScript:
<pre>
interface BoxIF {
  axis: Axis ;
  alignment: Alignment ;
  distribution: Distribution ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
declare function _alloc_Box(): BoxIF ;

</pre>
