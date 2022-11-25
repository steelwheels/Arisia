# `Icon` component

## Introduction
Clickable Icon.

This is sample view of Icon:
(The "OK" button is NOT an icon component.)

![Sample Icon](./Images/icon-component.png)

## Interface

This is the interface definition for TypeScript:
<pre>
interface IconIF extends FrameCoreIF {
  frameName: string ;
  image: string ;
  pressed(p0: IconIF): void ;
  propertyNames: string[] ;
  size: IconSize ;
  symbol: number ;
  title: string ;
}
declare function _alloc_Icon(): IconIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



