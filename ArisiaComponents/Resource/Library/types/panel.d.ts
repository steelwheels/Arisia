/// <reference path="ArisiaLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
declare function openPanel(title: string, type: FileType, exts: string[]): URLIF | null;
declare function savePanel(title: string): URLIF | null;
