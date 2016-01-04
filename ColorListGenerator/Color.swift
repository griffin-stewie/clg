//
//  Coor.swift
//  ColorListGenerator
//
//  Created by tokorom
//  https://github.com/tokorom/json2clr
//

import Foundation
import Cocoa

class Color {

    var name: String?
    var color: NSColor?

    init?(dictionary: NSDictionary) {
        var name: String?
        var color: NSColor?

        name = dictionary["name"] as? String

        if let hex = dictionary["hex"] as? String {
            let trimed = hex.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString:"#"))
            color = Color.colorFromHexString(trimed)
        } else {
            let red = dictionary["r"] as? String
            let green = dictionary["g"] as? String
            let blue = dictionary["b"] as? String
            let alpha = dictionary["a"] as? String
            color = Color.colorFromStrings(red: red, green: green, blue: blue, alpha: alpha)
        }

        if nil == name || nil == color {
            return nil
        } else {
            self.name = name
            self.color = color
        }
    }

    class func colorFromHexString(value: String) -> NSColor? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        let characters = Array(value.utf8)
        if 6 <= characters.count {
            red = Color.colorValue(characters[0], characters[1])
            green = Color.colorValue(characters[2], characters[3])
            blue = Color.colorValue(characters[4], characters[5])
        }
        if 8 <= characters.count {
            alpha = Color.colorValue(characters[6], characters[7])
        }

        return NSColor(deviceRed: red, green: green, blue: blue, alpha: alpha).colorUsingColorSpace(NSColorSpace.sRGBColorSpace())
    }

    class func colorValue(code1: UInt8, _ code2: UInt8) -> CGFloat {
        let k1 = Color.floatValueForCharacter(code1)
        let k2 = Color.floatValueForCharacter(code2)
        let value: CGFloat = CGFloat(k1) * 16.0 + CGFloat(k2)
        return CGFloat(value / 255.0)
    }

    class func floatValueForCharacter(code: UInt8) -> Int {
        switch code {
        case Array("0".utf8)[0]...Array("9".utf8)[0]: return Int(code - Array("0".utf8)[0])
        case Array("a".utf8)[0]...Array("z".utf8)[0]: return Int((code - Array("a".utf8)[0]) + 10)
        case Array("A".utf8)[0]...Array("Z".utf8)[0]: return Int((code - Array("A".utf8)[0]) + 10)
        default: return 0
        }
    }

    class func colorFromStrings(red red: String?, green: String?, blue: String?, alpha: String?) -> NSColor? {
        let r = Color.floatValueFromString(red) ?? 0.0
        let g = Color.floatValueFromString(green) ?? 0.0
        let b = Color.floatValueFromString(blue) ?? 0.0
        let a = Color.floatValueFromString(alpha) ?? 1.0
        return NSColor(deviceRed: r, green: g, blue: b, alpha: a).colorUsingColorSpace(NSColorSpace.sRGBColorSpace())
    }

    class func floatValueFromString(value: String?) -> CGFloat? {
        if let string = value {
            if let integer = Int(string) {
                return CGFloat(integer) / 255.0
            } else {
                return CGFloat((string as NSString).doubleValue)
            }
        }
        return nil
    }

    func hexStringRepresentation(needsHashMark: Bool = true) -> String {
        let x = self.color!
        func toInt(component: CGFloat) -> Int {
            return Int(component * 255.0)
        }

        let hex = toInt(x.redComponent) * 0x10000
            + toInt(x.greenComponent) * 0x100
            + toInt(x.blueComponent)
        let hexString = NSString(format: "%06x", hex).uppercaseString as String
        if needsHashMark {
            return "#" + hexString

        }
        return hexString
    }

}
