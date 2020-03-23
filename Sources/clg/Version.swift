//
//  Version.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/08.
//

import Foundation
import ArgumentParser

struct Version: ParsableArguments {
    
    @Flag(name: .shortAndLong, help: "Print version")
    var version: Bool

    let versionNumber = "2.1.0"

    func validate() throws {
        if version { throw CleanExit.message("version \(versionNumber)") }
    }
}
