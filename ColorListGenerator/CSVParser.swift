//
//  CSVParser.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/25.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import Cocoa

struct CSVParser {
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
        guard let r = Double(compos[1]), let g = Double(compos[2]), let b = Double(compos[3]) else {
            return nil
        }

        let name = compos[0]
        let red = CGFloat(r)
        let green = CGFloat(g)
        let blue = CGFloat(b)

        let color = NSColor(srgbRed: red, green: green, blue: blue, alpha: 1.0)


        return (color, name)
    }
}
