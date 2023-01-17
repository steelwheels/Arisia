# `TableData` component

## Introduction
The TableData component manages the database which contains
multiple data records.

## Interface

This is the interface definition for TypeScript:
<pre>
interface TableDataIF extends FrameIF {
  count: number ;
  fieldName(p0: string): string ;
  fieldNames: string[] ;
  newRecord(): RecordIF ;
  record(p0: number): RecordIF ;
  save(): boolean ;
  toString(): string ;
}
declare function _alloc_TableData(): TableDataIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



