# ArisiaCompiler specification
## Introduction

## Compile flow
The Arisia Platform recommends you to implement the application by TypeScript.
Your ArisiaScript will be translated into TypeScript (*.ts) and type declaration (*.d.ts).
Arisia Platform provides type declaration files for all built-in type, function and classes.

But the Arisia Platform does not have type script compiler.
So there are 2 compile flows.

###  1. The compile flow without TypeScript compiler
The ArisiaScript compiler parse the ArisiaScript and generate JavaScript program to execute it on the JavaScript engine. 

[pros]
* The TypeScript compiler is *not* required.

[cons]
* There are no type, syntax check. You must fix all bugs at application run time.

###  2. The compile flow with TypeScript compiler

[pros]
* Your code will be checked by TypeScript compiler. 

[cons]
* You have to install TypeScript compiler. You can download it from https://www.typescriptlang.org/download .
* You have to prepare build tool (such as Makefile).

### Compile flow
<p align="center">
<img src="./Images/compile-flow.png" width="75%" height="75%" />
</p>

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
