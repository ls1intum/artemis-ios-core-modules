//
//  StubVsImpl.swift
//
//
//  Created by Anian Schleyer on 05.06.24.
//

import Foundation

@propertyWrapper
public struct StubOrImpl<Proto> {
    public private(set) var wrappedValue: Proto

    public init(stub: Proto, impl: Proto) {
        if CommandLine.arguments.contains("-Screenshots") {
            wrappedValue = stub
        } else {
            wrappedValue = impl
        }
    }
}
