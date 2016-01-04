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
    case Unknown;
    case CLR;
    case JSON;
    case ASE;
    case CSV;
}

struct FileDetector {
    func detectFileType (a: NSData) -> FileType {
        return .Unknown
    }

    func detectFileType (a: String) -> FileType {
        let URL = NSURL(fileURLWithPath: a)
        return detectFileType(URL)
    }

    func detectFileType (a: NSURL) -> FileType {
        let str = a.absoluteString
        let ext = (str as NSString).pathExtension.lowercaseString
        switch ext {
        case "clr":
            return .CLR
        case "ase":
            return .ASE
        case "json":
            return .JSON
        case "csv":
            return .CSV
        case "txt":
            return .CSV
        default:
            return .Unknown
        }
    }

    func detectFileType (a: NSColorList) -> FileType {
        return .CLR
    }
}