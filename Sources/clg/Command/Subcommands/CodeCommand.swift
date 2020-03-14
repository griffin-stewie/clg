//
//  CodeCommand.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/08.
//

import Foundation
import ArgumentParser
import Path

extension Code: ExpressibleByArgument { }

struct CodeCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "code",
        abstract: " generates Swift code, Objective-C code, colors.xml from JSON"
    )

    @Option(name: [.customLong("code"), .customShort("c")], help: ArgumentHelp("generate specific type of code file", valueName: Code.allCasesDescription))
    var codeType: Code

    @Option(name: [.customLong("output"), .customShort("o")], default: Path.cwd/".", help: ArgumentHelp("Output directory that generated file will be saved.", valueName: "directory"))
    var outputPath: Path

    @Argument(help: ArgumentHelp("", valueName: "JSON file path"))
    var inputFilePath: Path
    
    func run() throws {
        let jsonData = try Data(contentsOf: inputFilePath.url)

        guard let colorDicts = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String:String]] else {
            throw RuntimeError("Invalid JSON file")
        }

        let colors: [Color] = colorDicts.map{ Color(dictionary: $0) }

        codeType.generateCode(colors, directory: outputPath.string)
    }
}
