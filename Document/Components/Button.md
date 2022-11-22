# `Button` component

## Introduction
A control that defines an area on the screen that a user clicks to trigger an action.

## Interface

This is the interface definition for TypeScript:
<pre>
interface ButtonIF extends FrameCoreIF {
  frameName: string ;
  isEnabled: boolean ;
  pressed(p0: ButtonIF): void ;
  propertyNames: string[] ;
  title: string ;
}
declare function _alloc_Button(): ButtonIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



