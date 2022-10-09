/**
 * Builtin.d.ts : Built-in objects in KiwiComponents
 */

declare function _enterView(path: string, arg: any, cbfunc: (retval: any) => void): void ;
declare function _alert(type: AlertType, message: string, labels: string[], cbfunc: (retval: number) => void): void ;

declare function leaveView(param: any): void ;


