# `Collection` component

## Introduction
Display multiple images. You cange callback by clicking the image.

## Interface

This is the interface definition for TypeScript:
<pre>
interface CollectionIF {
  columnNumber: number ;
  totalNumber(): number ;
  collection: string[] ;
  pressed(p0: CollectionIF, p1: number, p2: number): void ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
declare function _alloc_Collection(): CollectionIF ;

</pre>
