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
    var colorspace: String?
    var code: String?
    var paletteName: String?

    override func commandOption() -> CSNCommandOption? {
        let option = CSNCommandOption()
        option.register("output", shortcut: "o", keyName:nil , requirement: CSNCommandOptionRequirement.required)
        option.register("colorspace", shortcut: "c", keyName:nil , requirement: CSNCommandOptionRequirement.optional)
        return option
    }

    override func forCommandName(_ commandName: String) -> CSNCommand? {
        return nil
    }

    override func run(withArguments args: [Any]) -> Int32 {
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
        var jsonData: Data!
        if let inputPath: String = args[0] as? String {
            self.paletteName = palletteNameFromPath(inputPath)

            jsonData = try? Data(contentsOf: URL(fileURLWithPath: inputPath))
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

        let colorDicts: NSArray! = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray

        if nil == colorDicts {
            CSNPrintStandardError("Error: Color list JSON is nil")
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

        colors.forEach { c in
            let name = "\(c.name) \(c.hexStringRepresentation())"
            c.name = name
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

        let filePath = (outputPath as NSString).expandingTildeInPath

        if colorList.write(toFile: filePath) {
            CSNPrintStandardOutput("SUCCESS: saved to \(filePath)")
        } else {
            CSNPrintStandardOutput("FAILED: failed to save to \(filePath)")
        }

        return EXIT_SUCCESS
    }

    func palletteNameFromPath(_ path: String) -> String {
        let str = URL(fileURLWithPath: path).absoluteString
        let ext = (str as NSString).pathExtension
        let s = (str as NSString).lastPathComponent.replacingOccurrences(of: "." + ext, with: "", options: [], range: nil)
        //            println(s)
        return s
    }
}
