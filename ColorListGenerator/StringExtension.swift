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
        let string: NSMutableString = NSMutableString(string: self)
        var error: NSError? = nil;
        (string as NSMutableString).replaceOccurrencesOfString("_", withString: " ", options: .CaseInsensitiveSearch, range: NSMakeRange(0, self.characters.count))
        return NSString(string: string) as String
    }

    private func camelCaseToSpaceSeparatedString() -> String {
        let string: NSMutableString = NSMutableString(string: self)
        var error: NSError? = nil;
        string.replaceOccurrencesOfString("([A-Z\\d]+)([A-Z][a-z])", withString: "$1 $2", options: .RegularExpressionSearch, range: NSMakeRange(0, string.length))
        string.replaceOccurrencesOfString("([a-z\\d])([A-Z])", withString: "$1 $2", options: .RegularExpressionSearch, range: NSMakeRange(0, string.length))
        return NSString(string: string) as String
    }

    func camelCase() -> String {
        let baseString = self.snakeCaseToSpaceSeparatedString()
        let string: NSMutableString = NSMutableString(string: baseString)
        var error: NSError? = nil;
        do {
            let regex = try NSRegularExpression(pattern: "((\\s)+(.))", options: .CaseInsensitive)
            let trimed = baseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if let matches = regex.matchesInString(trimed, options: [], range: NSMakeRange(0, trimed.characters.count)) as? [NSTextCheckingResult] {
                for m in Array(matches.reverse()) {
                    let range = m.rangeAtIndex(0)
                    let upper = (trimed as NSString).substringWithRange(m.rangeAtIndex(3)).uppercaseString
                    (string as NSMutableString).replaceCharactersInRange(m.rangeAtIndex(1), withString: upper)
                }
            }
        } catch let error1 as NSError {
            error = error1
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

        var error: NSError? = nil;
        do {
            let regex = try NSRegularExpression(pattern: "((\\s)+(.))", options: .CaseInsensitive)
            if let matches = regex.matchesInString(string as String, options: [], range: NSMakeRange(0, (string as String).characters.count)) as? [NSTextCheckingResult] {
                for m in Array(matches.reverse()) {
                    let range = m.rangeAtIndex(0)
                    let lower = "_" + (string as NSString).substringWithRange(m.rangeAtIndex(3))
                    (string as NSMutableString).replaceCharactersInRange(m.rangeAtIndex(1), withString: lower)
                }
            }
        } catch let error1 as NSError {
            error = error1
        }

        return NSString(string: string.lowercaseString) as String
    }

    func sanitizeAsMethodName() -> String {
        let string: NSMutableString = NSMutableString(string: self)
        (string as NSMutableString).replaceOccurrencesOfString(".", withString: "_", options: [], range: NSMakeRange(0, self.characters.count))
        return NSString(string: string) as String
    }
}