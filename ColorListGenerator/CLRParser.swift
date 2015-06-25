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

        let k = colorList.allKeys
        if let keys = k as? [String] {
            for key in keys {
                if let color = colorList.colorWithKey(key) {
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

        return nil
    }
}