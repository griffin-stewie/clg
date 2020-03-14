//
//  Error.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/14.
//

import Foundation

struct RuntimeError: Error, CustomStringConvertible {
    var description: String

    init(_ description: String) {
        self.description = description
    }
}
