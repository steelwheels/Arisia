# Implementation

## Frameworks
* [ArisiaLibrary](https://github.com/steelwheels/Arisia/blob/main/ArisiaLibrary/README.md): Define the primitive data structure frame, and language parser.

## Data structure
### Frame
* [ALFrameCore Class](https://github.com/steelwheels/Arisia/blob/main/ArisiaLibrary/Source/Frame/ALFrameCore.swift): The core class to implement the frame. This object has the API which can be accessed by JavaScript program.
* [ALFrame Protocol](https://github.com/steelwheels/Arisia/blob/main/ArisiaLibrary/Source/Frame/ALFrame.swift): All component objects implement this protocol. This protocol has the API to access the [ALFrameCore](https://github.com/steelwheels/Arisia/blob/main/ArisiaLibrary/Source/Frame/ALFrameCore.swift) instance in it.

### Language parser
Following code supports [Arisia language](https://github.com/steelwheels/Arisia/blob/main/Document/arisia-lang.md).
* [ALFrameIR](https://github.com/steelwheels/Arisia/blob/main/ArisiaLibrary/Source/Language/ALIFrameIR.swift): The intermidiate representation for the arisia language.
* [ALParser](https://github.com/steelwheels/Arisia/blob/main/ArisiaLibrary/Source/Parser/ALParser.swift): The Arisia language parser.

# Related links
* [Steel Wheels Project](https://github.com/steelwheels): The developper's site
* [Arisia](https://github.com/steelwheels/Arisia/README.md): Main page for Arisia Programming Environment
* Arisia: The nama of the star in the novel [lensman](https://en.wikipedia.org/wiki/Lensman_series).
