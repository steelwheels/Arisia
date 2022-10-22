# `adecl` command

## Name
`adecl` - Generate type declaration file (`*.d.ts`)

## Synopsys
````
adecl [options] [frame-name]
````

## Description
The `adecl` command generates default type declaration files foreach built-in components which is defined in [ArisiaComponent](https://github.com/steelwheels/Arisia/tree/main/ArisiaComponents).
If *frame-name* argument is given, the type declaration file for given frame will be generated. If there is no argument, type declaration files for all built-in frames will be generated. 

### Options
#### `-h`, `--help`
Output help message and quit the command.

#### `--version`
Output the version information and quit the command.

### `-t`, `--target` *target*
The kind of target application. Select one target from `terminal`
or `window`. The default target is `terminal`.
This information is used the class of root frame.

# Reference
* [ArisiaTools](https://github.com/steelwheels/Arisia/tree/main/ArisiaTools): The framework which contains this command.
* [Arisia Programming Environment](https://github.com/steelwheels/Arisia/blob/main/README.md): The main page for Arisia Programming Environment.
