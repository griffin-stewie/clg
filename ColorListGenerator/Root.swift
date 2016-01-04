//
//  Root.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/17.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Cocoa
import Foundation

class Root: NSObject, CSNCommand {

    var executePath: String?
    var arguments: [String]?
    var version: NSNumber?
    var help: NSNumber?

    func commandOption() -> CSNCommandOption? {
        let option = CSNCommandOption()
        option.registerOption("version", shortcut: "v", keyName:nil , requirement: CSNCommandOptionRequirement.None)
        option.registerOption("help", shortcut: "h", keyName:nil , requirement: CSNCommandOptionRequirement.None)
        return option
    }

    func commandForCommandName(commandName: String) -> CSNCommand? {
        switch commandName {
        case "clr":
            return ToCLR()
        case "json":
            return ToJSON()
        case "code":
            return ToCode()
        default:
            return nil;
        }
    }

    func runWithArguments(args: [AnyObject]) -> Int32 {
        if let shouldShowVersion = self.version {
            if shouldShowVersion.boolValue {
                CSNPrintStandardOutput(kAppVersion)
                return EXIT_SUCCESS
            }
        }

        let h = Help()
        return h.runWithArguments(args)
    }
}
