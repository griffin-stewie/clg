//
//  Coor.swift
//  ColorListGenerator
//
//  Created by tokorom
//  https://github.com/tokorom/json2clr
//

import Foundation
import Cocoa

public class Color {

    struct ColorComponent {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat

        init(dict: [String:String]) {
            let values = Color.floatValuesFromStrings(
                red: dict["r"],
                green: dict["g"],
                blue: dict["b"],
                alpha: dict["a"]
            )

            red = values.red
            green = values.green
            blue = values.blue
            alpha = values.alpha
        }

        init(hex value: String) {
            let characters = Array(value.utf8)
            guard 6 <= characters.count else {
                preconditionFailure("illegal hex string")
            }

            red = Color.colorValue(characters[0], characters[1])
            green = Color.colorValue(characters[2], characters[3])
            blue = Color.colorValue(characters[4], characters[5])

            if 8 <= characters.count {
                alpha = Color.colorValue(characters[6], characters[7])
            } else {
                alpha = 1.0
            }
        }

        var color: NSColor {
            return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
        }
    }

    var colorComponent: ColorComponent

    var color: NSColor {
        return colorComponent.color
    }

    var name: String

    public init(dictionary: [String:String]) {
        name = dictionary["name"]!

        if let hex = dictionary["hex"] {
            let trimed = hex.trimmingCharacters(in: CharacterSet(charactersIn:"#"))
            colorComponent = ColorComponent(hex: trimed)
        } else {
            var dict = dictionary
            dict["name"] = nil
            colorComponent = ColorComponent(dict: dict)
        }
    }
}

extension Color {
    class func colorFromHexString(_ value: String) -> NSColor? {
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

        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
    }

    class func colorValue(_ code1: UInt8, _ code2: UInt8) -> CGFloat {
        let k1 = Color.floatValueForCharacter(code1)
        let k2 = Color.floatValueForCharacter(code2)
        let value: CGFloat = CGFloat(k1) * 16.0 + CGFloat(k2)
        return CGFloat(value / 255.0)
    }

    class func floatValueForCharacter(_ code: UInt8) -> Int {
        switch code {
        case Array("0".utf8)[0]...Array("9".utf8)[0]: return Int(code - Array("0".utf8)[0])
        case Array("a".utf8)[0]...Array("z".utf8)[0]: return Int((code - Array("a".utf8)[0]) + 10)
        case Array("A".utf8)[0]...Array("Z".utf8)[0]: return Int((code - Array("A".utf8)[0]) + 10)
        default: return 0
        }
    }

    class func floatValuesFromStrings(red: String?, green: String?, blue: String?, alpha: String?) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let r = Color.floatValueFromString(red) ?? 0.0
        let g = Color.floatValueFromString(green) ?? 0.0
        let b = Color.floatValueFromString(blue) ?? 0.0
        let a = Color.floatValueFromString(alpha) ?? 1.0
        return (r, g, b, a)
    }

    class func floatValueFromString(_ value: String?) -> CGFloat? {
        if let string = value {
            if let integer = Int(string) {
                return CGFloat(integer) / 255.0
            } else {
                return CGFloat((string as NSString).doubleValue)
            }
        }
        return nil
    }

    func hexStringRepresentation(_ needsHashMark: Bool = true) -> String {
        let x = self.color
        func toInt(_ component: CGFloat) -> Int {
            return Int(component * 255.0)
        }

        let hex = toInt(x.redComponent) * 0x10000
            + toInt(x.greenComponent) * 0x100
            + toInt(x.blueComponent)
        let hexString = NSString(format: "%06x", hex).uppercased as String
        if needsHashMark {
            return "#" + hexString

        }
        return hexString
    }
}

extension Color {

    /// returns dictionary contains r, g, b, a
    public func colorComponetsDictionary() -> [String:String] {
        return [
            "red" : "\(colorComponent.red)",
            "green" : "\(colorComponent.green)",
            "blue" : "\(colorComponent.blue)",
            "alpha" : "\(colorComponent.alpha)",
        ]
    }
}
