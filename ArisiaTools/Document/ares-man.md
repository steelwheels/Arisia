# `ares` command

## Name
`ares` - Arisia resource transpiler

## Synopsys
````
adecl [options] JavaScript-package
````

## Description
The `ares` command generates type declaration for storages in the package.
About the storage, see [storage definition](https://github.com/steelwheels/KiwiScript/blob/master/KiwiLibrary/Document/Storage/Storage.md).

### Options

#### `-h`, `--help`
Output help message and quit the command.

#### `--version`
Output the version information and quit the command.

### `-t`, `--target` *target*
The kind of target application. Select one target from `terminal`
or `window`. The default target is `terminal`.
This information is used the class of root frame.

### Parameters
You must give one *.jspkg directory as a parameter. This tool parse the
[manifest.info](https://github.com/steelwheels/JSTools/blob/master/Document/jspkg.md) file and output type declaration to standard output.

# Reference
* [ArisiaTools](https://github.com/steelwheels/Arisia/tree/main/ArisiaTools): The framework which contains this command.
* [Arisia Programming Environment](https://github.com/steelwheels/Arisia/blob/main/README.md): The main page for Arisia Programming Environment.
