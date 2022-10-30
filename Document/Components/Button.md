# `Button` component

## Introduction
A control that defines an area on the screen that a user clicks to trigger an action.

## Interface

This is the interface definition for TypeScript:
<pre>
interface ButtonIF {
  pressed(p0: ButtonIF): void ;
  isEnabled: boolean ;
  title: string ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
declare function _alloc_Button(): ButtonIF ;

</pre>
