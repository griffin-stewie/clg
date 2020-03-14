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
    static var configuration = CommandConfiguration(
        commandName: "clg",
        abstract: "clg, generates Color stuffs Swift code, Objective-C code, colors.xml, clr file, and JSON",
        subcommands: [
            CLRCommand.self,
            JSONCommand.self,
            CodeCommand.self,
        ]
    )

    @OptionGroup()
    var version: Version
}
