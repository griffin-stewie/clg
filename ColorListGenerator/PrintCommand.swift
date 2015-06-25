//
//  PrintCommand.swift
//  icnmod
//
//  Created by griffin-stewie on 2014/07/07.
//  Copyright (c) 2014 net.cyan-stivy. All rights reserved.
//

import Foundation

func CSNPrintStandardOutput(string: String, #needsProcessName: Bool) {
    let processName = NSProcessInfo.processInfo().processName
    var output = ""

    if needsProcessName {
        output = "[\(processName)]  \(string)\n"
    } else {
        output = "\(string)\n"
    }

    let fileHandle = NSFileHandle.fileHandleWithStandardOutput()

    if let d = output.dataUsingEncoding(NSUTF8StringEncoding) {
        fileHandle.writeData(d)
    }
}

func CSNPrintStandardOutput(strings: String...) {
    var concat = ""
    for str in strings {
        concat.extend(str)
    }
    CSNPrintStandardOutput(concat, needsProcessName:false)
}

func CSNDebugPrintStandardOutput(strings: String...) {
    var concat = ""
    for str in strings {
        concat.extend(str)
    }

#if DEBUG
    CSNPrintStandardOutput(concat)
#endif
}

func CSNPrintStandardError(string: String, #needsProcessName: Bool) {
    let processName = NSProcessInfo.processInfo().processName
    var output = ""

    if needsProcessName {
        output = "[\(processName)]  \(string)\n"
    } else {
        output = "\(string)\n"
    }
    let fileHandle = NSFileHandle.fileHandleWithStandardError()

    if let d = output.dataUsingEncoding(NSUTF8StringEncoding) {
        fileHandle.writeData(d)
    }
}

func CSNPrintStandardError(strings: String...) {
    var concat = ""
    for str in strings {
        concat.extend(str)
    }
    CSNPrintStandardError(concat, needsProcessName:false)
}