# ArisiaCompiler specification
## Introduction

## Compilation pahases
* parser pass
* linter pass
* linker pass
* optimizer pass
* transpiler pass

### Transpiler pass

## Transcript

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
