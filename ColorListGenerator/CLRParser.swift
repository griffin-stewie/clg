//
//  CLRParser.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/23.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import Cocoa

struct CLRParser {
    func parse(colorList: NSColorList) -> [[String : String]]? {
        var dicts = [[String : String]]()

        for key in colorList.allKeys {
            if let color = colorList.color(withKey: key) {
                var colorDict = [String : String]()
                colorDict["name"] = key
                colorDict["r"] = String(format: "%f", Double(color.redComponent))
                colorDict["g"] = String(format: "%f", Double(color.greenComponent))
                colorDict["b"] = String(format: "%f", Double(color.blueComponent))
                colorDict["a"] = String(format: "%f", Double(color.alphaComponent))
                dicts.append(colorDict)
            }
        }

        return dicts
    }
}
