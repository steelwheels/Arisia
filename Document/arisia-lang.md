# ArisiaScript specification

## Introduction
The ArisiaScript is the extension of TypeScript/JavaScript for event driven programming.

## Frame
The frame is a basic object which supports event driven programming.
The declaration is started by `{` and ended by `}`.
It contains multiple (zero or more) property declaration.
The `,` *is NOT* required between property declarations.
````
{
        name : property_value // property declaration
        ...
}
````

|Name |Description |
|--- |--- |
|`name`  |Property name. It must be unique in a frame. |
|`type`  |Data type. For more details, see [type](#type).|
|`value` |Property value. See [value](#value). |

The instance name of the top level frame is `root`.
You can not change this name.

## Type
The data type and their names are similar to TypeScript except the frame.

|Name           |Declaration    | Description           |
|---            |---            |---                    |
|boolean        |`boolean`      |`true` or `false`      |
|number         |`number`       |integer or floating point      |
|string         |`string`       |string                 |
|enum           | enum-ident    |Enum type name         |
|array          | etype`[]`     |array                  |
|dictionary     | `[name: string]:` etype |dictionary with the string key |
|frame          |frame-ident    |Type name of the frame |

The `etype` is type of element. 
The `frame-ident` and `enum-ident` is the built-in or user-defined idenfier.

## Value
### Immediate value
|Type           |Declaration    | Description           |
|---            |---            |---                    |
|boolean        |`true`         |true or false          |
|number         |0, 2, -1.3 , 0x1 |Integer or floating point value. Supported base is 10 (decimal) and 16 (hex) |
|string         |\"STR\"      |The character sequence between \" and \".  |

### Enum value
The enum value must be declared as identifier.
The identifier must be a predefined member of the enum type.

For example, the `horizontal` is the member of [Axis](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Enum/Axis.md) enum type.

````
{
  axis: Axis horizontal
}
````

### Function value
#### Init function
The init function is called to initialize the frame.
This function is called only once after this frame is allocated.

This function does not have the return value.
Even if you use `return` statement in it's body, the return value will be ignored.

You can define multiple init functions in a frame. In this case, they are called in declaration order.
````
{
 init0: init %{
    The JavaScript code to initialize the frame
  %}
}
````

The order of calling init function is depend on the declaration order of them.
In the following example, the execution order will be:
1. frameB - init0
2. frameA - init0
3. frameC - init0
4. frameA - init1

````
{
  frameA: Frame {
    frameB: Frame {
      init: %{ console.log("frameB - init0") ; %}
    } 
    init: %{ console.log("frameA - init0") ; %}
    frameC: Frame {
      init: %{ console.log("frameC - init0") ; %}
    }
    init: %{ console.log("frameA - init1") ; %}
  }
}
````

#### Event function
The event function is called by the frame to tell the event. For example, the button component calls `pressed` event when the button is pressed. The number and type of arguments will be defined by the frame.

This function does not have the return value.
Even if you use `return` statement in it's body, the return value will be ignored.
````
{
  button0: Button {
    pressed: event(pressed: bool) %{
      console.log("button0 is pressed") ;
    %}
  }
}
````

#### Listner function
The listner function is called when one of the parameter is changed.

In the following example, the listner function for property `sum0` listens the value of `root.a` and `root.b` and executed when of of them are changed.

The expression to point the object (such as `root.a`) is called as path expression. See [path expression](#path-expression) section.
````
{
  a: number 0   // Listned value
  b: number 1   // Listned value
  sum0: number listner(a: root.a, b: root.b) %{
    return a + b ;
  %}
}
````

#### Procedural function
### Expression value
````
{
  a: number %{ return 1 + 2 ; %}
}
````

### Array value
### Dictionary value
### Frame value

## Expression
### Path expression

## Comment
````
        // comment
````

## Reserved words
* boolean
* class
* event
* func
* init
* listner
* number
* root
* string

## Syntax
````
root    := "{" properties "}"
        ;
properties
        := /* Empty */
        |  properties property
        ;
property := IDENTIFIER ":"  property_value
        ;
property_value
        := type value
        |  init_function
        |  event_function
        ;
type    := element_type
        |  element_type "[" "]"         // for array type
        ;
element_type
        := scalar_type
        |  enum_type
        |  dictionary_type
        |  frame_type
        ;
scalar_type
        := BOOLEAN
        |  NUMBER
        |  STRING
        ;
enum_type
        := ENUM_TYPE_IDENTIFIER
        ;
dictionary_type
        := "[" + "name" + ":" + "string" + "]" + ":" + type
        ;
frame_type
        := FRAME_IDENTIFIER
        ;
value   := scalar_value
        |  enum_value
        |  expression_value
        |  array_value
        |  dictionary_value
        |  frame_value
        |  listner_function
        |  procedural_function
        ;
scalar_value
        := BOOLEAN_VALUE
        |  NUMBER_VALUE
        |  enum_value
        ;
enum_value
        :=  ENUM_MEMBER_IDENTIFIER
        ;
expression_value
        := ”％{" TEXT "%}"
        ;
array_value
        := "[" values "]"
        ;
dictionary_value
        := "[" dictionary_elements "]"
        ;
dictionary_elements
        := /* empty */
        |  dictionary_elements dictionary_element
        ;
dictionary_element
        := identifier ":" value
        ;
frame_value
        := "{" frames "}"
        ;
frames  := frame
        |  frame frames
        ;
frame   := "{" properties "}"
        ;
init_function
        := "init" script
        ;
event_function
        := "event" "(" arguments ")" script
        ;
listner_function
        := "listner" "(" path_arguments ")" script
        ;
procedural_function
        := "func" "(" arguments ")" script
        ;
arguments
        := /* empty */
        |  argument
        |  arguments "," argument
        ;
argument:
        := IDENTIFIER ":" type
        ;
path_arguments
        := /* empty */
        | path_argument
        | path_arguments "," path_argument
        ;
path_argument
        := IDENTIFIER ":" path_expression
        ;
script  := "%{" TEXT "%}"
        ;
````
The `ENUM_TYPE_IDENTIFIER` and the `FRAME_IDENTIFIER` are the pre-defined identifier.
The `TEXT` is the JavaScript code. The arisia parser doest not check it's context.

## Related links
* [README](https://github.com/steelwheels/Arisia): Introduction of arisia programming environment
* [compiler](./arisia-compiler.md): The compiler to compile the ArisiaScript 
