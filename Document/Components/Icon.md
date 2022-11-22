# `Icon` component

## Introduction
Clickable Icon.

This is sample view of Icon:
<img src="./Images/icon-component.png" width="50%" height="50%" />
(The "OK" button is NOT an icon component.)

## Interface

This is the interface definition for TypeScript:
<pre>
interface IconIF extends FrameCoreIF {
  frameName: string ;
  image: string ;
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



