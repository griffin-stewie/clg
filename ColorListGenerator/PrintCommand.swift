//
//  PrintCommand.swift
//  icnmod
//
//  Created by griffin-stewie on 2014/07/07.
//  Copyright (c) 2014 net.cyan-stivy. All rights reserved.
//

import Foundation

func CSNPrintStandardOutput(_ string: String, needsProcessName: Bool) {
    let processName = ProcessInfo.processInfo.processName
    var output = ""

    if needsProcessName {
        output = "[\(processName)]  \(string)\n"
    } else {
        output = "\(string)\n"
    }

    let fileHandle = FileHandle.standardOutput

    if let d = output.data(using: String.Encoding.utf8) {
        fileHandle.write(d)
    }
}

func CSNPrintStandardOutput(_ strings: String...) {
    var concat = ""
    for str in strings {
        concat.append(str)
    }
    CSNPrintStandardOutput(concat, needsProcessName:false)
}

func CSNDebugPrintStandardOutput(_ strings: String...) {
    var concat = ""
    for str in strings {
        concat.append(str)
    }

#if DEBUG
    CSNPrintStandardOutput(concat)
#endif
}

func CSNPrintStandardError(_ string: String, needsProcessName: Bool) {
    let processName = ProcessInfo.processInfo.processName
    var output = ""

    if needsProcessName {
        output = "[\(processName)]  \(string)\n"
    } else {
        output = "\(string)\n"
    }
    let fileHandle = FileHandle.standardError

    if let d = output.data(using: String.Encoding.utf8) {
        fileHandle.write(d)
    }
}

func CSNPrintStandardError(_ strings: String...) {
    var concat = ""
    for str in strings {
        concat.append(str)
    }
    CSNPrintStandardError(concat, needsProcessName:false)
}
