# `Collection` component

## Introduction
Display multiple images. You cange callback by clicking the image.

## Interface

This is the interface definition for TypeScript:
<pre>
interface CollectionIF extends FrameCoreIF {
  collection: string[] ;
  columnNumber: number ;
  frameName: string ;
  pressed(p0: CollectionIF, p1: number, p2: number): void ;
  propertyNames: string[] ;
  totalNumber(): number ;
}
declare function _alloc_Collection(): CollectionIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



