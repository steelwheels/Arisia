# `Button` component

## Introduction
A control that defines an area on the screen that a user clicks to trigger an action.

## Interface

This is the interface definition for TypeScript:
<pre>
interface ButtonIF {
  addObserver(p0: string, p1: () => void): void ;
  definePropertyType(p0: string, p1: string): void ;
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: ButtonIF): void ;
  propertyNames: string[] ;
  setValue(p0: string, p1: any): boolean ;
  title: string ;
  value(p0: string): any ;
}
declare function _alloc_Button(): ButtonIF ;

</pre>
