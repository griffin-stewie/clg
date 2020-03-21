//
//  Error.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/14.
//

import Foundation

public struct RuntimeError: Error, CustomStringConvertible {
    public var description: String

    public init(_ description: String) {
        self.description = description
    }
}
