//
//  main.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/05/15.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation

let kAppVersion = "0.3.0"

let result = CSNCommandLineParser.run(with: Root())

exit(Int32(result))
