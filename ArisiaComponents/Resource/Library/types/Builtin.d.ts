/**
 * Builtin.d.ts : Built-in objects in KiwiComponents
 */

declare function _enterView(path: string, arg: any, cbfunc: (retval: any) => void): void ;
declare function _alert(type: AlertType, message: string, labels: string[], cbfunc: (retval: number) => void): void ;
declare function leaveView(param: any): void ;

declare function _openPanel(title: string, type: FileType, exts: string[], cbfunc: any): void ;
declare function _savePanel(title: string, cbfunc: any): void ;


