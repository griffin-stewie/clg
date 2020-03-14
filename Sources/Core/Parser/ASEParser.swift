//
//  ASEParser.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/21.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import CoreFoundation
import Foundation
import Cocoa

// https://github.com/hughsk/adobe-swatch-exchange
// https://github.com/m99coder/ase2json
// https://github.com/ramonpoca/ColorTools

extension Data {

    func readUInt32BE(_ position : Int) -> UInt32 {
        var blocks : UInt32 = 0
        (self as NSData).getBytes(&blocks, length: position)
        return NSSwapBigIntToHost(blocks)
    }

    func readUInt16BE(_ position : Int) -> UInt16 {
        var blocks : UInt16 = 0
        (self as NSData).getBytes(&blocks, length: position)
        return NSSwapBigShortToHost(blocks)
    }

    func readUInt32LE(_ position : Int) -> UInt32 {
        var blocks : UInt32 = 0
        (self as NSData).getBytes(&blocks, length: position)
        return NSSwapLittleIntToHost(blocks)
    }

    func readUInt8(_ position : Int) -> UInt8 {
        var blocks : UInt8 = 0
        (self as NSData).getBytes(&blocks, length: position)
        return blocks
    }
}

let SIGNATURE = "ASEF"

enum ColorMode: String {
    case CM_CMYK = "CMYK"
    case CM_RGB = "RBG"
    case CM_LAB = "LAB"
    case CM_GRAY = "Gray"
}

enum ColorType: Int {
    case ct_GLOBAL = 0
    case ct_SPOT = 1
    case ct_NORMAL = 2
}

let MODE_COLOR = 1
let MODE_GROUP = 2

enum ParseState: Int {
    case getMode = 1
    case getLength = 2
    case getName = 3
    case getModel = 4
    case getColor = 5
    case getType = 6
}

struct ParseModel {
    var data: Data
    var blocks: UInt32
    var state = ParseState.getMode
    var mode = MODE_COLOR
    var position = 12
    var blockLength: UInt32

    init(_ d: Data) {
        data = d
        blocks = data.readUInt32BE(8)
        blockLength = 0
    }

    func canGo() -> Bool {
        return position < data.count
    }

    mutating func addPosition(_ a: Int) {
        position += a
    }
}

public struct ASEParser {
    let BT_GROUP_START: UInt16 = 0xc001
    let BT_GROUP_END: UInt16 = 0xc002
    let BT_COLOR_ENTRY: UInt16 = 0x0001
    var colorList = NSColorList(name: "x")

    func parse(url: URL) -> NSColorList? {
        return parse(path: url.path)
    }

    func parse(path: String) -> NSColorList? {
        guard let ASEFileHandle = FileHandle(forReadingAtPath:path) else  {
            return nil
        }

        let header = ASEFileHandle.readData(ofLength: 4)
        if header != Data(bytes: UnsafePointer<UInt8>(SIGNATURE), count: 4) {
            NSLog("%s %@", #function, "this file is not ASE");
            return nil
        }

        let majVData: Data = ASEFileHandle.readData(ofLength: 2)
        let minVData: Data = ASEFileHandle.readData(ofLength: 2)
        let nblocksData: Data = ASEFileHandle.readData(ofLength: 4)

        _ = minVData.readUInt16BE(minVData.count)
        _ = majVData.readUInt16BE(majVData.count)
        let nBlocks:UInt32 = nblocksData.readUInt32BE(nblocksData.count)

        //NSLog("Version %d.%d, blocks %d", majV, minV, nBlocks);

        for _ in 0..<nBlocks {
            self.readBlock(ASEFileHandle)
        }


        return colorList
    }

    func readBlock(_ fileHandle :FileHandle) {
        let blockType: UInt16 = fileHandle.readUInt16()!
        let blockLength: UInt32 = fileHandle.readUInt32()!

        switch blockType {
        case BT_COLOR_ENTRY:
            let nameLength: UInt16 = fileHandle.readUInt16()!
            let nameData: Data = fileHandle.readData(ofLength: Int(nameLength * 2))
            var name = String(data: nameData, encoding: String.Encoding.utf8)
            let colorModelData: Data = fileHandle.readData(ofLength: 4)
            if let colorModel = NSString(data: colorModelData, encoding: String.Encoding.ascii.rawValue) {
                let color = colorFromModel(colorModel, fileHandle: fileHandle)
                _ = fileHandle.readUInt16()

                if name == nil || name == "\0" {
                    let convertedColor = color.usingColorSpaceName(NSColorSpaceName.deviceRGB)!;

                    let hexString = String(format: "#%02X%02X%02X"
                        , Int(convertedColor.redComponent * 0xFF)
                        , Int(convertedColor.greenComponent * 0xFF)
                        , Int(convertedColor.blueComponent * 0xFF));
                    name = hexString
                } else {
                    var set = CharacterSet.controlCharacters
                    set.formUnion(CharacterSet.whitespacesAndNewlines)
                    name = name?.trimmingCharacters(in: set)
                }

                var i :Int = 1;
                var fixedName :String = name!
                while (self.colorList.color(withKey: fixedName) != nil) {
                    i += i
                    let s = String(format: " %ld", i)
                    fixedName = name!.appending(s)
                }

                name = fixedName

                self.colorList.setColor(color, forKey: name!)
            }

        default:
            fileHandle.readData(ofLength: Int(blockLength))
        }
    }

    func colorFromModel(_ colorModel: NSString, fileHandle: FileHandle) -> NSColor {
        switch colorModel {
        case "RGB ":
            let red :CGFloat = CGFloat(fileHandle.readFloat()!)
            let green :CGFloat = CGFloat(fileHandle.readFloat()!)
            let blue :CGFloat = CGFloat(fileHandle.readFloat()!)
            let color = NSColor(srgbRed: red, green: green, blue: blue, alpha: 1.0)
            return color
        case "CMYK":
            let cyan :CGFloat = CGFloat(fileHandle.readFloat()!)
            let magenta :CGFloat = CGFloat(fileHandle.readFloat()!)
            let yellow :CGFloat = CGFloat(fileHandle.readFloat()!)
            let black :CGFloat = CGFloat(fileHandle.readFloat()!)
            let color = NSColor(deviceCyan: cyan, magenta: magenta, yellow: yellow, black: black, alpha: 1.0).usingColorSpace(NSColorSpace.sRGB)!
            return color
        case "LAB ":
            assertionFailure("Unsupport Color Model")
        case "Gray":
            let white :CGFloat = CGFloat(fileHandle.readFloat()!)
            let color = NSColor(white: white, alpha: 1.0).usingColorSpace(NSColorSpace.sRGB)!
            return color
        default:
            assertionFailure("Unkonw Color Model")
        }

        return NSColor.black
    }
}

