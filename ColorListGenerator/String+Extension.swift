//
//  String+Extension.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/18.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation

extension String {

    private func snakeCaseToSpaceSeparatedString() -> String {
        return self.stringByReplacingOccurrencesOfString("_", withString: " ", options: .CaseInsensitiveSearch, range: nil)
    }

    private func camelCaseToSpaceSeparatedString() -> String {
        return self.stringByReplacingOccurrencesOfString("([A-Z\\d]+)([A-Z][a-z])", withString: "$1 $2", options: .RegularExpressionSearch, range: nil)
        .stringByReplacingOccurrencesOfString("([a-z\\d])([A-Z])", withString: "$1 $2", options: .RegularExpressionSearch, range: nil)
    }

    func camelCase() -> String {
        let baseString = self.snakeCaseToSpaceSeparatedString()
        let string: NSMutableString = NSMutableString(string: baseString)
        let regex = try! NSRegularExpression(pattern: "((\\s)+(.))", options: .CaseInsensitive)
        let trimed = baseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let matches = regex.matchesInString(trimed, options: [], range: NSRange(location: 0, length: trimed.characters.count))
        for m in matches.reverse() {
            let upper = (trimed as NSString).substringWithRange(m.rangeAtIndex(3)).uppercaseString
            (string as NSMutableString).replaceCharactersInRange(m.rangeAtIndex(1), withString: upper)
        }

        if string.length > 0 {
            let firstLetterRange = NSMakeRange(0, 1)
            let lowercasedFirstLetter = string.substringWithRange(firstLetterRange).lowercaseString;
            string.replaceCharactersInRange(firstLetterRange, withString: lowercasedFirstLetter)
        }

        return NSString(string: string) as String
    }

    func snakeCase() -> String {
        let baseString = self.snakeCaseToSpaceSeparatedString().camelCaseToSpaceSeparatedString().stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let string: NSMutableString = NSMutableString(string: baseString)
        let regex = try! NSRegularExpression(pattern: "((\\s)+(.))", options: .CaseInsensitive)
        let matches = regex.matchesInString(string as String, options: [], range: NSMakeRange(0, (string as String).characters.count))
        for m in Array(matches.reverse()) {
            let lower = "_" + (string as NSString).substringWithRange(m.rangeAtIndex(3))
            (string as NSMutableString).replaceCharactersInRange(m.rangeAtIndex(1), withString: lower)
        }

        return NSString(string: string.lowercaseString) as String
    }

    func sanitizeAsMethodName() -> String {
        let string: NSMutableString = NSMutableString(string: self)
        (string as NSMutableString).replaceOccurrencesOfString(".", withString: "_", options: [], range: NSMakeRange(0, self.characters.count))
        return NSString(string: string) as String
    }
}