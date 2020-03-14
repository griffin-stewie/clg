//
//  CLRParser.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/23.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import Cocoa

public struct CLRParser {
    func parse(colorList: NSColorList) -> [[String : String]]? {
        var dicts = [[String : String]]()

        for key in colorList.allKeys {
            if let color = colorList.color(withKey: key) {
                var colorDict = [String : String]()
                colorDict["name"] = key
                colorDict["r"] = NSString(format: "%f", Double(color.redComponent)) as String
                colorDict["g"] = NSString(format: "%f", Double(color.greenComponent)) as String
                colorDict["b"] = NSString(format: "%f", Double(color.blueComponent)) as String
                colorDict["a"] = NSString(format: "%f", Double(color.alphaComponent)) as String
                dicts.append(colorDict)
            }
        }

        return dicts
    }
}
