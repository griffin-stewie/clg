//
//  CodeGenerator.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/18.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation

enum Code: String {
    case Swift = "swift"
    case ObjC = "objc"
    case Android = "android"

    func generateCode(colors: [Color], directory: String) {
        switch self {
        case .Swift:
            func classFunc(color: Color) -> String {

                let methodName: String
                if let cName = color.name {
                    methodName = cName.camelCase().sanitizeAsMethodName() + "Color()"
                } else {
                    methodName = "cName" + "Color()"
                }

                var code = "    class func \(methodName) -> UIColor {\n" +
                    "        return UIColor(red: \(Double(color.color!.redComponent)), green: \(Double(color.color!.greenComponent)), blue: \(Double(color.color!.blueComponent)), alpha: \(Double(color.color!.alphaComponent)))\n" +
                "    }\n\n"
                return code
            }

            func generateSwiftFile(colors: [Color], directory: String) {
                var code = "import UIKit"
                         + "\n"
                         + "\n"
                         + "extension UIColor {"
                         + "\n"
                for c in colors {
                    code += classFunc(c)
                }

                code += "}"

                var e: NSError? = nil

                if let URL = NSURL(fileURLWithPath:directory.stringByAppendingPathComponent("AppColors.swift").stringByStandardizingPath), let path = URL.path {
                    let result = code.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &e)
                    if result {
                        CSNPrintStandardOutput("SUCCESS: saved to \(path)")
                    }
                    #if DEBUG
                        println(e)
                        println(result)
                    #endif
                } else {
                    CSNPrintStandardOutput("FAILED: failed to save swift extension file")
                }
            }

            generateSwiftFile(colors, directory)

        case .ObjC:
            func classMethodInterface(color: Color) -> String {

                let methodName: String
                if let cName = color.name {
                    methodName = cName.camelCase().sanitizeAsMethodName() + "Color"
                } else {
                    methodName = "cName" + "Color()"
                }


                var code = "+ (UIColor *)clr_\(methodName);\n\n"
                return code
            }

            func classMethodImplementation(color: Color) -> String {

                let methodName: String
                if let cName = color.name {
                    methodName = cName.camelCase().sanitizeAsMethodName() + "Color"
                } else {
                    methodName = "cName" + "Color()"
                }

                var code = "+ (UIColor *)clr_\(methodName)\n" +
                "{\n" +
                "    return [UIColor colorWithRed:\(Double(color.color!.redComponent)) green:\(Double(color.color!.greenComponent)) blue:\(Double(color.color!.blueComponent)) alpha:\(Double(color.color!.alphaComponent))];\n" +
                "}\n\n"
                return code
            }

            func generateObjCHeaderFile(colors: [Color], fileName: String) {
                var code = "@import UIKit;"
                    + "\n"
                    + "\n"
                    + "@interface UIColor (CLRGeneratedAdditions)"
                    + "\n"
                    + "\n"

                for c in colors {
                    code += classMethodInterface(c)
                }

                code += "@end"

                var e: NSError? = nil

                let filePath = directory.stringByAppendingPathComponent("UIColor+CLRGeneratedAdditions.h").stringByStandardizingPath
                if let URL = NSURL(fileURLWithPath:filePath), let path = URL.path {
                    let result = code.writeToFile(path,
                        atomically: true,
                        encoding: NSUTF8StringEncoding,
                        error: &e)
                    if result {
                        CSNPrintStandardOutput("SUCCESS: saved to \(path)")
                    }
                    #if DEBUG
                        println(e)
                        println(result)
                    #endif
                } else {
                    CSNPrintStandardOutput("FAILED: failed to save swift extension file")
                }
            }

            func generateObjCImplementationFile(colors: [Color], fileName: String) {
                let headerFileName = "UIColor+CLRGeneratedAdditions.h"
                var code = "#import \"\(headerFileName)\""
                         + "\n"
                         + "\n"
                         + "@implementation UIColor (CLRGeneratedAdditions)"
                         + "\n"
                         + "\n"

                for c in colors {
                    code += classMethodImplementation(c)
                }

                code += "@end"

                var e: NSError? = nil
                let filePath = directory.stringByAppendingPathComponent("UIColor+CLRGeneratedAdditions.m").stringByStandardizingPath
                if let URL = NSURL(fileURLWithPath:filePath), let path = URL.path {
                    let result = code.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &e)
                    if result {
                        CSNPrintStandardOutput("SUCCESS: saved to \(path)")
                    }
                    #if DEBUG
                        println(e)
                        println(result)
                    #endif
                } else {
                    CSNPrintStandardOutput("FAILED: failed to save swift extension file")
                }

            }

            generateObjCHeaderFile(colors, directory)
            generateObjCImplementationFile(colors, directory)

        case .Android:
            func colorElement(color: Color) -> String {
                let name: String
                if let cName = color.name {
                    name = cName.snakeCase().sanitizeAsMethodName()
                } else {
                    name = "cName"
                }
                return "    <color name=\"\(name)\">\(color.hexStringRepresentation())</color>\n"
            }

            func generateColorXMLFile(colors: [Color], fileName: String) {
                var code = "<!-- Palette generated by clg -->"
                    + "\n"
                    + "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                    + "\n"
                    + "<resources>"
                    + "\n"

                for c in colors {
                    code += colorElement(c)
                }

                code += "</resources>"

                var e: NSError? = nil
                let filePath = directory.stringByAppendingPathComponent("colors.xml").stringByStandardizingPath
                if let URL = NSURL(fileURLWithPath:filePath), let path = URL.path {
                    let result = code.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: &e)
                    if result {
                        CSNPrintStandardOutput("SUCCESS: saved to \(path)")
                    }
                    #if DEBUG
                        println(e)
                        println(result)
                    #endif
                } else {
                    CSNPrintStandardOutput("FAILED: failed to save swift extension file")
                }
            }

            generateColorXMLFile(colors, directory)
        default:
            CSNPrintStandardError("Unkonow code type")
        }
    }

}

