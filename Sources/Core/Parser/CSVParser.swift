//
//  CSVParser.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/25.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import Cocoa

public struct CSVParser {
    func parse(_ CSVText: String) -> NSColorList? {
        let colorList :NSColorList = NSColorList(name: "x")
        CSVText.enumerateLines { (line, stop) -> () in
            if let taple = self.parseLine(line) {
                colorList.setColor(taple.color, forKey: taple.name)
            }
        }

        if colorList.allKeys.count == 0 {
            return nil
        }

        return colorList
    }


    func parseLine(_ text: String) -> (color :NSColor, name :String)? {
        let compos = text.components(separatedBy: ",")
        if compos.count != 4 {
            return nil
        }

        let name = compos[0]
        let red = CGFloat((compos[1] as NSString).doubleValue)
        let green = CGFloat((compos[2] as NSString).doubleValue)
        let blue = CGFloat((compos[3] as NSString).doubleValue)

        let color = NSColor(srgbRed: red, green: green, blue: blue, alpha: 1.0)


        return (color, name)
    }
}
