# Arisia Programming Environment

<div style="text-align: center">
<img src="./Document/Images/arisia-title.png" alt="Arisia Icon" width="50%" height="50%">
</div>v

## Introduction
The *Arisia Programming Environment* is application software development environment for macOS and iOS.

It targets on *rappid GUI application development*.
To reduce the amount code to implement the application.
this environment has following features:
* Programming based on event driven software architecture. The [ArisiaScript](#arisiascript-language) support it.
* [ArisiaLibrary](#arisia-library) has many predefined components to implement GUI application which uses database access.

This environment assumes the platform allows the application to execute the JavaScript code in it. 
Now, the targets platforms are:
* macOS
* iOS

## ArisiaScript language
The *ArisiaScript* extends the syntax of [TypeScript](https://www.typescriptlang.org) to support [frame](#frame) declaration.
For more details, see [ArisiaScript language specification](./Document/arisia-lang.md).

### Frame
The arisia script defines the *frame*. It is the super class of all objects. 
The frame will have following items to support event driven programming.
* Observable properties
* Listner methods

This is sample frame implementation:
````
{
        // property variable
        member_a : number 0
}
````

### Component
The component is the class which inherit the frame class.
It is used to implement the following parts of the application:
* GUI parts
* Database access modules

## Arisia Transcriptor
The arisia transcriptor parse the amber script and generate the JavaScript code.


## Arisia Library
The arisia library contains many kind of [components](#component).

### Built-in native component
### Built-in script component
### User defined component

## Arisia Runtime

# Related links
* [Steel Wheels Project](https://github.com/steelwheels)
* [ArisiaTools](https://github.com/steelwheels/Arisia/tree/main/ArisiaTools): Command line tools for development 
* [Arisia](https://en.wikipedia.org/wiki/Lensman_series): The name of 

