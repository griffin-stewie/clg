//
//  Help.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/02.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Cocoa
import Foundation

class Help: Root {
    override func commandForCommandName(commandName: String) -> CSNCommand? {
        return nil
    }

    override func runWithArguments(args: [AnyObject]) -> Int32 {
        CSNPrintStandardOutput(
            "Usage:\n",
            "\n",
            "    $ clg COMMAND\n",
            "\n",
            "     clg, generates Color stuffs Swift code, Objective-C code, colors.xml, clr file, and JSON\n",
            "\n",
            "Coomands:\n",
            "\n",
            "    clr    generates clr file from JSON\n",
            "    json   generates JSON from clr file OR CSV file OR ASE file a.k.a. \"Adobe Swatch Exchange\"\n",
            "    code   generates Swift code, Objective-C code, colors.xml from JSON\n",
            "    help   show help\n",
            "\n",
            "Options:\n",
            "\n",
            "    --version, v  print the version\n",
            "    --help, h     show help\n"
        )
        return EXIT_SUCCESS
    }
}
