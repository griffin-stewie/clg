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

extension NSData {

    func readUInt32BE(position : Int) -> UInt32 {
        var blocks : UInt32 = 0
        self.getBytes(&blocks, length: position)
        return NSSwapBigIntToHost(blocks)
    }

    func readUInt16BE(position : Int) -> UInt16 {
        var blocks : UInt16 = 0
        self.getBytes(&blocks, length: position)
        return NSSwapBigShortToHost(blocks)
    }

    func readUInt32LE(position : Int) -> UInt32 {
        var blocks : UInt32 = 0
        self.getBytes(&blocks, length: position)
        return NSSwapLittleIntToHost(blocks)
    }

    func readUInt8(position : Int) -> UInt8 {
        var blocks : UInt8 = 0
        self.getBytes(&blocks, length: position)
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
    case CT_GLOBAL = 0
    case CT_SPOT = 1
    case CT_NORMAL = 2
}

let MODE_COLOR = 1
let MODE_GROUP = 2

enum ParseState: Int {
    case GetMode = 1
    case GetLength = 2
    case GetName = 3
    case GetModel = 4
    case GetColor = 5
    case GetType = 6
}

struct ParseModel {
    var data: NSData
    var blocks: UInt32
    var state = ParseState.GetMode
    var mode = MODE_COLOR
    var position = 12
    var blockLength: UInt32

    init(_ d: NSData) {
        data = d
        blocks = data.readUInt32BE(8)
        blockLength = 0
    }

    func canGo() -> Bool {
        return position < data.length
    }

    mutating func addPosition(a: Int) {
        position += a
    }
}

struct ASEParser {
    let BT_GROUP_START: UInt16 = 0xc001
    let BT_GROUP_END: UInt16 = 0xc002
    let BT_COLOR_ENTRY: UInt16 = 0x0001
    var colorList = NSColorList(name: "x")

    func parse(path: String) -> NSColorList? {
        if let ASEFileHandle = NSFileHandle(forReadingAtPath:path) {
            let header = ASEFileHandle.readDataOfLength(4)
            if header != NSData(bytes: SIGNATURE, length: 4) {
                NSLog("%s %@", __FUNCTION__, "this file is not ASE");
                return nil
            }

            let majVData: NSData = ASEFileHandle.readDataOfLength(2)
            let minVData: NSData = ASEFileHandle.readDataOfLength(2)
            let nblocksData: NSData = ASEFileHandle.readDataOfLength(4)

            let minV:UInt16 = minVData.readUInt16BE(minVData.length)
            let majV:UInt16 = majVData.readUInt16BE(majVData.length)
            let nBlocks:UInt32 = nblocksData.readUInt32BE(nblocksData.length)

            //NSLog("Version %d.%d, blocks %d", majV, minV, nBlocks);

            for _ in 0..<nBlocks {
                self.readBlock(ASEFileHandle)
            }
        }

        return colorList
    }

    func readBlock(fileHandle :NSFileHandle) {
        let blockType: UInt16 = fileHandle.readDataOfLength(2).bigEndianUInt16()
        let blockLength: UInt32 = fileHandle.readDataOfLength(4).bigEndianUInt32()

        switch blockType {
        case BT_COLOR_ENTRY:
            let nameLength: UInt16 = fileHandle.readDataOfLength(2).bigEndianUInt16()
            let nameData: NSData = fileHandle.readDataOfLength(Int(nameLength * 2))
            var name = NSString(data: nameData, encoding: NSUTF16BigEndianStringEncoding)
            let colorModelData: NSData = fileHandle.readDataOfLength(4)
            if let colorModel = NSString(data: colorModelData, encoding: NSASCIIStringEncoding) {
                let color = colorFromModel(colorModel, fileHandle: fileHandle)
                let type: UInt16 = fileHandle.readDataOfLength(2).bigEndianUInt16()

                if name == nil || name == "\0" {
                    let convertedColor = color.colorUsingColorSpaceName(NSDeviceRGBColorSpace)!;

                    let hexString = NSString(format: "#%02X%02X%02X"
                        , Int(convertedColor.redComponent * 0xFF)
                        , Int(convertedColor.greenComponent * 0xFF)
                        , Int(convertedColor.blueComponent * 0xFF));
                    name = hexString;
                } else {
                    let set = NSMutableCharacterSet.controlCharacterSet()
                    set.formUnionWithCharacterSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    name = name?.stringByTrimmingCharactersInSet(set)
                }

                var i :NSInteger = 1;
                var fixedName :NSString = name!;
                while (self.colorList.colorWithKey(fixedName as String) != nil) {
                    i += i++
                    let s = NSString(format: " %ld", i)
                    fixedName = name!.stringByAppendingString(s as String)
                }

                name = fixedName;

                self.colorList.setColor(color, forKey: name as! String)
            }

        default:
            fileHandle.readDataOfLength(Int(blockLength))
        }
    }

    func colorFromModel(colorModel: NSString, fileHandle: NSFileHandle) -> NSColor {
        switch colorModel {
        case "RGB ":
            let red :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let green :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let blue :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let color = NSColor(SRGBRed: red, green: green, blue: blue, alpha: 1.0)
            return color
        case "CMYK":
            let cyan :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let magenta :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let yellow :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let black :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let color = NSColor(deviceCyan: cyan, magenta: magenta, yellow: yellow, black: black, alpha: 1.0).colorUsingColorSpace(NSColorSpace.sRGBColorSpace())!
            return color
        case "LAB ":
            assertionFailure("Unsupport Color Model")
        case "Gray":
            let white :CGFloat = CGFloat(fileHandle.readDataOfLength(4).bigEndianFloat32())
            let color = NSColor(white: white, alpha: 1.0).colorUsingColorSpace(NSColorSpace.sRGBColorSpace())!
            return color
        default:
            assertionFailure("Unkonw Color Model")
        }

        return NSColor.blackColor()
    }
}

