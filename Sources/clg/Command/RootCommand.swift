//
//  Root.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/17.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import ArgumentParser

struct RootCommand: ParsableCommand {
    fileprivate static let version = "2.1.0"
    static var configuration = CommandConfiguration(
        commandName: "clg",
        abstract: "clg, generates Color stuffs: Swift code, Objective-C code, Color Set, colors.xml, clr file, and JSON",
        version: version,
        subcommands: [
            CLRCommand.self,
            JSONCommand.self,
            CodeCommand.self,
        ]
    )
}
