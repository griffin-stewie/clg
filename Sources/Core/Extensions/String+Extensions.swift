//
//  String+Extension.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/18.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation

extension String {

    fileprivate func snakeCaseToSpaceSeparatedString() -> String {
        return self.replacingOccurrences(of: "_", with: " ", options: .caseInsensitive, range: nil)
    }

    fileprivate func camelCaseToSpaceSeparatedString() -> String {
        return self.replacingOccurrences(of: "([A-Z\\d]+)([A-Z][a-z])", with: "$1 $2", options: .regularExpression, range: nil)
        .replacingOccurrences(of: "([a-z\\d])([A-Z])", with: "$1 $2", options: .regularExpression, range: nil)
    }

    public func camelCase() -> String {
        let baseString = self.snakeCaseToSpaceSeparatedString()
        let string: NSMutableString = NSMutableString(string: baseString)
        let regex = try! NSRegularExpression(pattern: "((\\s)+(.))", options: .caseInsensitive)
        let trimed = baseString.trimmingCharacters(in: CharacterSet.whitespaces)
        let matches = regex.matches(in: trimed, options: [], range: NSRange(location: 0, length: trimed.count))
        for m in matches.reversed() {
            let upper = (trimed as NSString).substring(with: m.range(at: 3)).uppercased()
            (string as NSMutableString).replaceCharacters(in: m.range(at: 1), with: upper)
        }

        if string.length > 0 {
            let firstLetterRange = NSMakeRange(0, 1)
            let lowercasedFirstLetter = string.substring(with: firstLetterRange).lowercased();
            string.replaceCharacters(in: firstLetterRange, with: lowercasedFirstLetter)
        }

        return NSString(string: string) as String
    }

    public func snakeCase() -> String {
        let baseString = self.snakeCaseToSpaceSeparatedString().camelCaseToSpaceSeparatedString().trimmingCharacters(in: CharacterSet.whitespaces)
        let string: NSMutableString = NSMutableString(string: baseString)
        let regex = try! NSRegularExpression(pattern: "((\\s)+(.))", options: .caseInsensitive)
        let matches = regex.matches(in: string as String, options: [], range: NSMakeRange(0, (string as String).count))
        for m in Array(matches.reversed()) {
            let lower = "_" + (string as NSString).substring(with: m.range(at: 3))
            (string as NSMutableString).replaceCharacters(in: m.range(at: 1), with: lower)
        }

        return NSString(string: string.lowercased) as String
    }

    public func sanitizeAsMethodName() -> String {
        let string: NSMutableString = NSMutableString(string: self)
        (string as NSMutableString).replaceOccurrences(of: ".", with: "_", options: [], range: NSMakeRange(0, self.count))
        return NSString(string: string) as String
    }
    
    public func appending(pathComponent: String) -> String {
        return NSString(string: self).appendingPathComponent(pathComponent)
    }
    
    public func standardizingPath() -> String {
        return NSString(string: self).standardizingPath
    }
}
