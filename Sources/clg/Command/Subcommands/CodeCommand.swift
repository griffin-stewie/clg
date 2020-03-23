//
//  CodeCommand.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/08.
//

import Foundation
import ArgumentParser
import Path
import Core

extension Code: ExpressibleByArgument { }

struct CodeCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "code",
        abstract: "generates Swift code, Objective-C code, Color Set, colors.xml from input"
    )

    @Option(name: [.customLong("code"), .customShort("c")], help: ArgumentHelp("Generate specific type of code file", valueName: Code.allCasesDescription))
    var codeType: Code

    @Option(name: [.customLong("output"), .customShort("o")], default: Path.cwd/".", help: ArgumentHelp("Output directory that generated file will be saved. (default: current directory)", valueName: "directory"))
    var outputPath: Path

    @Argument(help: ArgumentHelp("Supported file types are \(FileType.allCasesDescription)", valueName: "input file"))
    var inputFilePath: Path

    func run() throws {
        let fileType = try FileType(from: inputFilePath.url)

        guard let colorList = fileType.colorListFrom(url: inputFilePath.url) else {
            throw RuntimeError("Could not load \(inputFilePath.string)")
        }

        codeType.generateCode(colorList.colors, directory: outputPath.string)
    }
}
