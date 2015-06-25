//
//  CLR.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/17.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Cocoa
import Foundation

class ToCLR: Root {
    var output: String?
    var code: String?
    var paletteName: String?

    override func commandOption() -> CSNCommandOption? {
        let option = CSNCommandOption()
        option.registerOption("output", shortcut: "o", keyName:nil , requirement: CSNCommandOptionRequirement.Required)
        return option
    }

    override func commandForCommandName(commandName: String) -> CSNCommand? {
        return nil
    }

    override func runWithArguments(args: [AnyObject]) -> Int32 {
        if let shouldShowHelp = self.help {
            if shouldShowHelp.boolValue {
                CSNPrintStandardOutput("help for clr subcommand")
                return EXIT_SUCCESS
            }
        }

        let args = args.filter{v in
            if v is String {
                return true
            }

            return false
        }

//        println(args)
//        println(self.output);
        var jsonData: NSData!
        if let inputPath: String = args[0] as? String {
            self.paletteName = palletteNameFromPath(inputPath)

            jsonData = NSData(contentsOfFile: inputPath)
            if nil == jsonData {
                CSNPrintStandardError("\(inputPath) was not found.")
                exit(-1)
            }
        }

        let paletteName: String
        if let p = self.paletteName {
            paletteName = p
        } else {
            paletteName = "clrgen"
        }

        var error: NSError?
        let colorDicts: NSArray! = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSArray

        if nil == colorDicts {
            CSNPrintStandardError("Error: \(error)")
            exit(-1)
        }

        CSNDebugPrintStandardOutput(colorDicts.description)

        var colors = [Color]()
        for d in colorDicts {
            if let dict = d as? NSDictionary {
                if let color = Color(dictionary: dict) {
                    colors.append(color)
                }
            }
        }

        let colorList = NSColorList(name: paletteName)

        for color in colors {
            if let clr = color.color {
                colorList.setColor(clr, forKey: color.name ?? "New")
            }
        }
        CSNDebugPrintStandardOutput("# \(colorList)")

        let outputPath: String
        if let a = self.output {
            outputPath = a
        } else {
            outputPath = "~/Library/Colors/\(paletteName).clr"
        }

        let filePath = (outputPath as NSString).stringByExpandingTildeInPath

        if colorList.writeToFile(filePath) {
            CSNPrintStandardOutput("SUCCESS: saved to \(filePath)")
        } else {
            CSNPrintStandardOutput("FAILED: failed to save to \(filePath)")
        }

        return EXIT_SUCCESS
    }

    func palletteNameFromPath(path: String) -> String {
        if let URL = NSURL(fileURLWithPath: path), let str = URL.absoluteString {
            let ext = str.pathExtension
            let s = str.lastPathComponent.stringByReplacingOccurrencesOfString("." + ext, withString: "", options: nil, range: nil)
//            println(s)
            return s
        }

        return "CLRGen"
    }
}
