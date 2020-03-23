//
//  NSColorList+Extensions.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/14.
//

import Cocoa

public extension NSColorList {
    func toJSON() -> [[String : String]] {
        return CLRParser().parse(colorList: self)
    }

    func toJSONData() -> Data? {
        let dicts = CLRParser().parse(colorList: self)
        if dicts.isEmpty {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: dicts, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}

public extension NSColorList {
    var colors: [Color] {
        return self.toJSON().map { Color(dictionary:$0) }
    }
}
