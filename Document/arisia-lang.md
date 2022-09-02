# Arisia programming language

## Introduction
The arisia programming language is the extension of TypeScript/JavaScript for event driven programming.

## Comment
````
        // comment
````

## Type
The data type and their names are similar to TypeScript except the frame.

|Name           |Declaration    | Description           |
|---            |---            |---                    |
|boolean        |`boolean`      |`true` or `false`      |
|number         |`number`       |integer or floating point      |
|string         |`string`       |string                 |
|array          | etype`[]`     |array                  |
|dictionary     | `[key: string]:` etype |dictionary. the key must be string. |
|init function  |`init`         |The type for [init function](#init-function) |
|event function  |`event`       |The type for [event function](#event-function) |
|listner function |`listner`    |The type for [listner function](#listner-function) |
|procedural function |`func`    |The type for [procedural function](#procedural-function) |
|frame          |frame-ident    |Type name of the frame |

The `etype` is type of element. The `frame-ident` is the
* built-in frame name
* user defined framename

## Immediate values
|Name           |Declaration    | Description           |
|---            |---            |---                    |
|boolean        |`true`         |true or false          |

## Frame
The frame declaration is started by `{` and ended by `}`.
It contains multiple (zero or more) property declaration.
The `,` *is NOT* required between property declarations.
````
{
        name : type body // property declaration
        ...
}
````

|Name |Description |
|--- |--- |
|`name` |Property name. It must be unique in a frame. |
|`type` |Data type. For more details, see [type](#type).|
|`body` |The [Immediate value](#immediate-values) or the [compound statement](#compound-statement). |

The instance name of the top level frame is `top`.
You can not change this name.

### Compound statement
````
{
        hello: func(a: number, b: number) %{
                return a + b ;
        %}
}
````

## Functions
### Init function
### Event function
### Listner function
### Procedural function



## Related links
* [README](https://github.com/steelwheels/Arisia): Introduction of arisia programming environment

