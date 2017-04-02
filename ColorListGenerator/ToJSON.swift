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
        option.register("output", shortcut: "o", keyName:nil , requirement: CSNCommandOptionRequirement.required)
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
            case .clr:
                if let colorList = NSColorList(name: "x", fromFile: (inputPath as NSString).expandingTildeInPath) {
                    if writeJSONFromColorList(colorList, outputPath: outputPath) {
                        return EXIT_SUCCESS
                    } else {
                        return EXIT_FAILURE
                    }
                } else {
                    return EXIT_FAILURE
                }
            case .ase:
                if let colorList = ASEParser().parse(inputPath) {
                    if writeJSONFromColorList(colorList, outputPath: outputPath) {
                        return EXIT_SUCCESS
                    } else {
                        return EXIT_FAILURE
                    }
                } else {
                    return EXIT_FAILURE
                }
            case .csv:
                let fileURL = URL(fileURLWithPath: inputPath)
                if let text = (try? NSString(contentsOf:fileURL , encoding: String.Encoding.utf8.rawValue)) as? String {
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

    func writeJSONFromColorList(_ colorList :NSColorList, outputPath :String) -> Bool {
        if let dicts = CLRParser().parse(colorList: colorList) {
            if let jsonData = try? JSONSerialization.data(withJSONObject: dicts, options: JSONSerialization.WritingOptions.prettyPrinted) {
                let filePath = (outputPath as NSString).expandingTildeInPath
                if (try? jsonData.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil {
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

    func palletteNameFromPath(_ path: String) -> String {
        let str = URL(fileURLWithPath: path).absoluteString
        let ext = (str as NSString).pathExtension
        let s = (str as NSString).lastPathComponent.replacingOccurrences(of: "." + ext, with: "", options: [], range: nil)
        //            println(s)
        return s
    }
}
