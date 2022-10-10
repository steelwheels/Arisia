# `asc` command

## Name
`asc` - Arisia Script Compiler

## Synopsys
````
asc [options] input-arisia-script-file-name
````

## Description
The `asc` command is Arisia Script Compiler. It compile [ArisiaScript](https://github.com/steelwheels/Arisia/blob/main/Document/arisia-lang.md) file and output the [JavaScript](https://en.wikipedia.org/wiki/JavaScript), [TypeScript](https://en.wikipedia.org/wiki/TypeScript) or [type declaration File (*.d.ts)](https://en.wikipedia.org/wiki/TypeScript) for it.

### Options
#### `-h`, `--help`
Output help message and quit the command.

#### `--version`
Output the version information and quit the command.

#### `-f`, `--format` *format*:
The format of output file. Select one format from `JavaScript`, `TypeScript` or `TypeDeclaration`. The default format is `JavaScript`.

### `-t`, `--target` *target*
The kind of target application. Select one target from `terminal`
or `window`. The default target is `terminal`.
This information is used the class of root frame.

# Reference
* [ArisiaTools](https://github.com/steelwheels/Arisia/tree/main/ArisiaTools): The framework which contains this command.
* [Arisia Programming Environment](https://github.com/steelwheels/Arisia/blob/main/README.md): The main page for Arisia Programming Environment.



