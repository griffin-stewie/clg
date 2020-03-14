//
//  NSColorList+Extensions.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/14.
//

import Cocoa

extension NSColorList {
    func toJSON() -> [[String : String]]? {
        return CLRParser().parse(colorList: self)
    }

    func toJSONData() -> Data? {
        guard let dicts = CLRParser().parse(colorList: self) else {
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: dicts, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}
