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
        option.register("version", shortcut: "v", keyName:nil , requirement: CSNCommandOptionRequirement.none)
        option.register("help", shortcut: "h", keyName:nil , requirement: CSNCommandOptionRequirement.none)
        return option
    }

    func forCommandName(_ commandName: String) -> CSNCommand? {
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
    
    func run(withArguments args: [Any]) -> Int32 {
        if let shouldShowVersion = self.version {
            if shouldShowVersion.boolValue {
                CSNPrintStandardOutput(kAppVersion)
                return EXIT_SUCCESS
            }
        }
        
        let h = Help()
        return h.run(withArguments: args)
    }
}
