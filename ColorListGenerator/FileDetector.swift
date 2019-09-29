//
//  FileDetector.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/23.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import Cocoa

enum FileType {
    case unknown;
    case clr;
    case json;
    case ase;
    case csv;
}

struct FileDetector {
    func detectFileType (_ a: Data) -> FileType {
        return .unknown
    }

    func detectFileType (_ a: String) -> FileType {
        let URL = Foundation.URL(fileURLWithPath: a)
        return detectFileType(URL)
    }

    func detectFileType (_ a: URL) -> FileType {
        let str = a.absoluteString
        let ext = (str as NSString).pathExtension.lowercased()
        switch ext {
        case "clr":
            return .clr
        case "ase":
            return .ase
        case "json":
            return .json
        case "csv":
            return .csv
        case "txt":
            return .csv
        default:
            return .unknown
        }
    }

    func detectFileType (_ a: NSColorList) -> FileType {
        return .clr
    }
}
