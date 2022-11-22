# `TableData` component

## Introduction
The TableData component manages the database which contains
multiple data records.

## Interface

This is the interface definition for TypeScript:
<pre>
interface TableDataIF extends FrameCoreIF {
  count: number ;
  fieldName(): string ;
  fieldNames: string[] ;
  frameName: string ;
  index: number ;
  newRecord: RecordIF ;
  path: string ;
  propertyNames: string[] ;
  record: RecordIF | null ;
  storage: string ;
}
declare function _alloc_TableData(): TableDataIF ;

</pre>

# Related links
* [Arisia Platform](https://github.com/steelwheels/Arisia#readme)
* [Steel Wheels Project](https://github.com/steelwheels)



