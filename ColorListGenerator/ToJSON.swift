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


        var jsonData: NSData!
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
                if let colorList = NSColorList(name: "x", fromFile: inputPath.stringByExpandingTildeInPath) {
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
                if let fileURL = NSURL(fileURLWithPath: inputPath) , let text = NSString(contentsOfURL:fileURL , encoding: NSUTF8StringEncoding, error: nil) as? String {
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
        let k = colorList.allKeys

        if let dicts = CLRParser().parse(colorList) {
            if let jsonData = NSJSONSerialization.dataWithJSONObject(dicts, options: NSJSONWritingOptions.PrettyPrinted, error: nil) {
                let filePath = (outputPath as NSString).stringByExpandingTildeInPath
                if jsonData.writeToFile(filePath, atomically: true) {
                    println("SUCCESS: saved to \(filePath)")
                } else {
                    println("FAILED: failed to save to \(filePath)")
                }
            }

            return true

        } else {
            return false
        }
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
