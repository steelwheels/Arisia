# `enterView` function
Allocate new child view and switch the current view to it.
This function is finished after new child view is closed by [leaveView](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Function/leaveView.md) function call.

## Prototype
The `enterView` function allocate new view. The parameter `arg` is passed to the view. The return value is given by [leaveView](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Function/leaveView.md).
````
function enterView(path: string, arg: any): any
````

## Parameter(s)
The parameter can have some different data type to give the location of script file.

|Name      |Type   |Description                        |
|:--       |:--    |:--                                |
|name      |string |The name of view component. The name must be define in `subviews` section in the [manifest file](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md).|
|arg       |any    |The argument to pass to the new view. The global variable `Argument` will have copy of it. |

If you want to pass the multiple vakues as argument,
pass the object value (such as `{a:v0, b:v1, ...}`) which contains them.

## Return value
This value will be given as the parameter of [leaveView](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Function/leaveView.md) function.
The data type is `any`. You have to know the type of return value of `enterView`.
It is defined by ｀leaveView` function which is corresponding to it.

## Example
This full implementation of this example is [enter-view.jspkg](https://github.com/steelwheels/JSTerminal/tree/master/Resource/Sample/enter-view.jspkg).


This is main-view. By pressing Subview button, the `enterView` function will be called. The 2nd arcgument `"Hello"` is passed to the subview. You can get the value by reading `Argument` global variable in the script for subview.

The return value of `enterView` function is the copy of argument of `leaveView` function. In the following exapmple. the variable `ret` will have following object:
`{message: string, a: number, b: number}`.

````
top: VBox {
    enter_button: Button {
        title: "SubView"
        pressed: Event() %{
            let ret = enterView("sub", "Hello from main view") ;
            console.log("message: " + ret.message + ", a  = "
                     + ret.a + ", b = " + ret.b) ;
        %}
    }
    quit_button: Button {
        ...
    }
    ...
}
````

This is sub view. The `leaveView` function is used to back to the previous view.

````
top: VBox {
    quit_button: Button {
        title: "Quit"
        pressed: Event() %{
            leaveView({
                message: "Good bye sub view",
                a: 10,
                b: 20
            }) ;
        %}
    }
    init: Init %{
        console.log("sub.init") ;
        console.log("argument = " + Argument) ;
    %}
}
````

Execution result:
````
jsh> run
Hello, world !!
main.init
sub.init
argument = Hello from main view
message: Good bye sub view, a  = 10, b = 20
exit-code = 0
jsh>
````

## References
programming by Amber.
* [leaveView](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Function/leaveView.md): Return to previous view
* [Library](https://github.com/steelwheels/KiwiCompnents/blob/master/Document/Library.md): Library for GUI
* [Kiwi Component Framework](https://github.com/steelwheels/KiwiCompnents): Document of this framework.


