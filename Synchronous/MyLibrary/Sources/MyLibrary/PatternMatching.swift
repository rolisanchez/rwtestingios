//
//  File.swift
//  
//
//  Created by Victor Rolando Sanchez Jara on 7/15/20.
//

//public func ~= <Value>(
//    pattern: KeyPath<Value, Bool>,
//    value: Value
//) -> Bool {
//    value[keyPath: pattern]
//}

// Below interprets KeyPAths too like above
public func ~= <Value>(
    pattern: (Value) -> Bool,
    value: Value
) -> Bool {
    pattern(value)
}
