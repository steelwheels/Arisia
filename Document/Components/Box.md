# `Box` component

## Introduction
The box to pack some components.
They will be layouted holizontally or vertically.

## Interface

This is the interface definition for TypeScript:
<pre>
interface BoxIF extends FrameCoreIF {
  alignment: Alignment ;
  axis: Axis ;
  distribution: Distribution ;
  frameName: string ;
  propertyNames: string[] ;
}
declare function _alloc_Box(): BoxIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



