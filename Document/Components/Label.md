# `Label` component

## Introduction
Display text/number field

## Interface

This is the interface definition for TypeScript:
<pre>
interface LabelIF {
  text: string ;
  number: number ;
  frameName: string ;
  value(p0: string): any ;
  setValue(p0: string, p1: any): boolean ;
  propertyNames: string[] ;
  definePropertyType(p0: string, p1: string): void ;
  addObserver(p0: string, p1: () => void): void ;
}
declare function _alloc_Label(): LabelIF ;

</pre>

## Sample
<pre>
{
  label: Label {
    text: string "Hello, World !!"
  }
  ok_button: Button {
        title: string "OK"
        pressed: event() %{
	    	leaveView(1) ;
        %}
  }
}


</pre>

For more details, see [hello.jspkg](https://github.com/steelwheels/Arisia/tree/main/ArisiaCard/Resource/Samples/hello.jspkg).

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



