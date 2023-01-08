# `Collection` component

## Introduction
Display multiple images. You cange callback by clicking the image.

## Interface

This is the interface definition for TypeScript:
<pre>
interface CollectionIF extends FrameIF {
  collection: string[] ;
  columnNumber: number ;
  pressed(p0: CollectionIF, p1: number, p2: number): void ;
  totalNumber(): number ;
}
declare function _alloc_Collection(): CollectionIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



