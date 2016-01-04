//
//  ToJSON.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/19.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Cocoa

class ToJSON: Root {
    var output: String?
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
        let args = args.filter{v in
            if v is String {
                return true
            }

            return false
        }

        //        println(args)
        //        println(self.output);


        if let inputPath: String = args[0] as? String {

            self.paletteName = palletteNameFromPath(inputPath)
            let paletteName: String
            if let p = self.paletteName {
                paletteName = p
            } else {
                paletteName = "clrgen"
            }

            let outputPath: String
            if let a = self.output {
                outputPath = a
            } else {
                outputPath = "\(paletteName).json"
            }

            let fileType = FileDetector().detectFileType(inputPath)
            switch fileType {
            case .CLR:
                if let colorList = NSColorList(name: "x", fromFile: (inputPath as NSString).stringByExpandingTildeInPath) {
                    if writeJSONFromColorList(colorList, outputPath: outputPath) {
                        return EXIT_SUCCESS
                    } else {
                        return EXIT_FAILURE
                    }
                } else {
                    return EXIT_FAILURE
                }
            case .ASE:
                if let colorList = ASEParser().parse(inputPath) {
                    if writeJSONFromColorList(colorList, outputPath: outputPath) {
                        return EXIT_SUCCESS
                    } else {
                        return EXIT_FAILURE
                    }
                } else {
                    return EXIT_FAILURE
                }
            case .CSV:
                let fileURL = NSURL(fileURLWithPath: inputPath)
                if let text = (try? NSString(contentsOfURL:fileURL , encoding: NSUTF8StringEncoding)) as? String {
                    if let colorList = CSVParser().parse(text) {
                        if writeJSONFromColorList(colorList, outputPath: outputPath) {
                            return EXIT_SUCCESS
                        } else {
                            return EXIT_FAILURE
                        }
                    } else {
                        return EXIT_FAILURE
                    }
                } else {
                    return EXIT_FAILURE
                }
            default:
                return EXIT_FAILURE
            }

        } else {
            return EXIT_FAILURE
        }
    }

    func writeJSONFromColorList(colorList :NSColorList, outputPath :String) -> Bool {
        if let dicts = CLRParser().parse(colorList) {
            if let jsonData = try? NSJSONSerialization.dataWithJSONObject(dicts, options: NSJSONWritingOptions.PrettyPrinted) {
                let filePath = (outputPath as NSString).stringByExpandingTildeInPath
                if jsonData.writeToFile(filePath, atomically: true) {
                    print("SUCCESS: saved to \(filePath)")
                } else {
                    print("FAILED: failed to save to \(filePath)")
                }
            }

            return true

        } else {
            return false
        }
    }

    func palletteNameFromPath(path: String) -> String {
        let str = NSURL(fileURLWithPath: path).absoluteString
        let ext = (str as NSString).pathExtension
        let s = (str as NSString).lastPathComponent.stringByReplacingOccurrencesOfString("." + ext, withString: "", options: [], range: nil)
        //            println(s)
        return s
    }
}
