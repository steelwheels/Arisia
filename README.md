# Arisia Platform

<p align="center">
<img src="./Document/Images/arisia-title.png" alt="Arisia Icon" width="50%" height="50%">
</p>

## Introduction
The *Arisia Platform* is the software platform for the rapid application software development.
The [ArisiaCard](./ArisiaCard/README.md) is an implementation of it.

For rapid application development, the following matters are required:
* The programming language that allows writing your ideas directory.
* Rich built-in components that eliminate the needs to reinvent the wheel
* The platform which supports multiple target OS and hardware

This platform has following features to meet these requirements:
* Extend the TypeScript syntax to support event driven programming. The language is named [ArisiaScript](#arisiascript-language).
* Usual GUI parts are implemented as built-in components. See [component list](./Document/arisia-components.md).
* The application designed for Arisia Platform runs on [macOS](https://www.apple.com/macos/) and [iOS](https://www.apple.com/ios/). 

## Sample screen shot
This is a simple example of ArisiaScript program.
````
{
  button: Button {
    title: string "Hello, world !!"
    pressed: event() %{
      console.log("Pressed") ;
    %}
  }
}
````
There are sample screen shots which is executed on MacOS and iOS.

<p align="center">
<img src="./Document/Images/hello-1.png" width="75%" height="75%" />
</p>

## License
Copyright (C) 2014-2022 [Steel Wheels Project](http://steelwheels.github.io).
This software is distributed under [GNU LESSER GENERAL PUBLIC LICENSE Version 2.1](https://www.gnu.org/licenses/lgpl-2.1-standalone.html) and the document is distributed under [GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).

## Dowload
* Source code: https://github.com/steelwheels
* AooStore: Not released yet

## Software for development Arisia Platform
The macOS machine is required to use them:
* [Xcode](https://developer.apple.com/xcode/resources/): The most impotant platform to develop macOS and iOS application software.
* [Type Script Compiler](https://www.typescriptlang.org): Arisia Platform recommeds to write script by TypeScript. But you can write *raw* JavaScript instead of it.
* Unix tools: You can use them at "Terminal" application in your Mac.

## Frameworks to build ArisiaPlatform
The [Steel Wheels Project](https://github.com/steelwheels) releases following software. They will be used to build Arisia Platform software.


## Arisia Component
See the [component list](./Document/arisia-components.md).

## Arisia Library
Many built-in classes, functions and data types are supported. See the [Kiwi Standard Library](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Library.md).

## Software development environment
### Compile flow
The Arisia Platform recommends you to implement the application by TypeScript.
Your ArisiaScript will be translated into TypeScript (*.ts) and type declaration (*.d.ts).
Arisia Platform provides type declaration files for all built-in type, function and classes.

But the Arisia Platform does not have type script compiler.
So there are 2 compile flows.

####  1. The compile flow without TypeScript compiler
The ArisiaScript compiler parse the ArisiaScript and generate JavaScript program to execute it on the JavaScript engine. 

[pros]
* The TypeScript compiler is *not* required.

[cons]
* There are no type, syntax check. You must fix all bugs at application run time.

####  2. The compile flow with TypeScript compiler

[pros]
* Your code will be checked by TypeScript compiler. 

[cons]
* You have to install TypeScript compiler. You can download it from https://www.typescriptlang.org/download .
* You have to prepare build tool (such as Makefile).

#### Compile flow
<p align="center">
<img src="./Document/Images/compile-flow.png" width="75%" height="75%" />
</p>

# References
* [Implementation](./Document/arisia-implementation.md): The implementation of this software

# Related links
* [Steel Wheels Project](https://github.com/steelwheels)
* [ArisiaCard](./ArisiaCard/README.md): The implementation of Arisia Platform. 
* [ArisiaTools](./ArisiaTools/README.md): Command line tools for development 
* Arisia: The name of the star in the novel [lensman](https://en.wikipedia.org/wiki/Lensman_series)

