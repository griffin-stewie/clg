//
//  StringExtension.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/18.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation

extension String {

    private func snakeCaseToSpaceSeparatedString() -> String {
        var string: NSMutableString = NSMutableString(string: self)
        var error: NSError? = nil;
        (string as NSMutableString).replaceOccurrencesOfString("_", withString: " ", options: .CaseInsensitiveSearch, range: NSMakeRange(0, count(self)))
        return NSString(string: string) as String
    }

    private func camelCaseToSpaceSeparatedString() -> String {
        var string: NSMutableString = NSMutableString(string: self)
        var error: NSError? = nil;
        string.replaceOccurrencesOfString("([A-Z\\d]+)([A-Z][a-z])", withString: "$1 $2", options: .RegularExpressionSearch, range: NSMakeRange(0, string.length))
        string.replaceOccurrencesOfString("([a-z\\d])([A-Z])", withString: "$1 $2", options: .RegularExpressionSearch, range: NSMakeRange(0, string.length))
        return NSString(string: string) as String
    }

    func camelCase() -> String {
        let baseString = self.snakeCaseToSpaceSeparatedString()
        var string: NSMutableString = NSMutableString(string: baseString)
        var error: NSError? = nil;
        if let regex = NSRegularExpression(pattern: "((\\s)+(.))", options: .CaseInsensitive, error: &error) {
            let trimed = baseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if let matches = regex.matchesInString(trimed, options: nil, range: NSMakeRange(0, count(trimed))) as? [NSTextCheckingResult] {
                for m in matches.reverse() {
                    let range = m.rangeAtIndex(0)
                    let upper = (trimed as NSString).substringWithRange(m.rangeAtIndex(3)).uppercaseString
                    (string as NSMutableString).replaceCharactersInRange(m.rangeAtIndex(1), withString: upper)
                }
            }
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
        var string: NSMutableString = NSMutableString(string: baseString)

        var error: NSError? = nil;
        if let regex = NSRegularExpression(pattern: "((\\s)+(.))", options: .CaseInsensitive, error: &error) {
            if let matches = regex.matchesInString(string as String, options: nil, range: NSMakeRange(0, count(string as String))) as? [NSTextCheckingResult] {
                for m in matches.reverse() {
                    let range = m.rangeAtIndex(0)
                    let lower = "_" + (string as NSString).substringWithRange(m.rangeAtIndex(3))
                    (string as NSMutableString).replaceCharactersInRange(m.rangeAtIndex(1), withString: lower)
                }
            }
        }

        return NSString(string: string.lowercaseString) as String
    }

    func sanitizeAsMethodName() -> String {
        var string: NSMutableString = NSMutableString(string: self)
        (string as NSMutableString).replaceOccurrencesOfString(".", withString: "_", options: nil, range: NSMakeRange(0, count(self)))
        return NSString(string: string) as String
    }
}