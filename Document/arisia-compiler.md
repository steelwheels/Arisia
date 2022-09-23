# ArisiaCompiler specification
## Introduction

## Compilation pahases
1. parser pass
2. transpiler pass
3. linker pass
4. evaluation pass

## 1. Parser pass
The parser checks the syntax of source code and generate intermediate code.

## 2. Transpiler pass
The transpiler generate the JavaScript code to allocate frame object and it's properties.

### Procedural function
The procedural function object will be assigned as a property.

*Source code*:
````
 sum: func(a:number, b:number):number %{
    return a + b
  %}
````

*Transpiled code*:
````
  frame.sum = function(a, b) {
    return a + b ;
  };
````

### Init function
The init function will be called before activating the frame.
````
{
  init0: init %{
    console.log("Hello") ;
  %}
}
````
This is an output of transcriptor.
````
root._init0_ifunc = function(self) {
        console.log("Hello") ;
} ;
````

## 3. Linker pass

## 4. Setup pass

# Reference
* [README](https://github.com/steelwheels/Arisia): Introduction of arisia programming environment
