//
//  ToCode.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/26.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Cocoa
import Foundation

class ToCode: Root {
    @objc var output: String?
    @objc var code: String?
    var paletteName: String?

    override func commandOption() -> CSNCommandOption? {
        let option = CSNCommandOption()
        option.register("output", shortcut: "o", keyName:nil , requirement: CSNCommandOptionRequirement.required)
        option.register("code", shortcut: "c", keyName:nil , requirement: CSNCommandOptionRequirement.required)
        return option
    }

    override func forCommandName(_ commandName: String) -> CSNCommand? {
        return nil
    }

    override func run(withArguments args: [Any]) -> Int32 {
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

        let outputPath: String
        if let a = self.output {
            outputPath = a
        } else {
            outputPath = "."
        }

        let filePath = (outputPath as NSString).expandingTildeInPath

        let codeType: String
        if let a = self.code {
            codeType = a
        } else {
            codeType = "swift"
        }

        if let c = Code(rawValue:codeType) {
            c.generateCode(colors, directory:filePath)
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

    func generateCodeFile(colors: [Color], code: String) {
        Code(rawValue:code)?.generateCode(colors, directory:".")
    }
}
