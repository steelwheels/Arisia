/**
 * Transpiler.ts
 */

/// <reference path="types/KiwiLibrary.d.ts"/>
/// <reference path="types/Builtin.d.ts"/>

export function _definePropertyIF(frame: FrameCoreIF, usernames: string[]) {
        /* merge default property names and user defined property names */
        let names = frame.propertyNames ;
        for(let uname of usernames) {
                if(!names.includes(uname)) {
                    names.push(uname) ;    
                }
        }
        /* define properties */
        for(let name of names) {
                Object.defineProperty(frame, name, {
                        get()    { return this.value(name) ;   },
                        set(val) { this.setValue(name, val) ;  }
                }) ;
        }
}

