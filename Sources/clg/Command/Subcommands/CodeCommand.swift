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

    @Option(name: [.customLong("code"), .customShort("c")], help: ArgumentHelp("Generate specific type of code file", discussion: "<Deprecated> Use `--type` option instead.", valueName: Code.allCasesDescription, shouldDisplay: false))
    var _deprecatedCodeType: Code?

    @Option(name: [.customLong("type"), .customShort("t")], help: ArgumentHelp("Generate specific type of code file", valueName: Code.allCasesDescription))
    var _codeType: Code?

    var codeType: Code {
        if let d = _deprecatedCodeType {
            return d
        }

        return _codeType!
    }

    @Option(name: [.customLong("output"), .customShort("o")], help: ArgumentHelp("Output directory that generated file will be saved. (default: current directory)", valueName: "directory"))
    var outputPath: Path = Path.cwd/"."

    @Argument(help: ArgumentHelp("Supported file types are \(FileType.allCasesDescription)", valueName: "input file"))
    var inputFilePath: Path

    func validate() throws {
        if _deprecatedCodeType != nil {
            var stderr = FileHandle.standardError
            print("<Deprecated> `--code` is deprecated. Use `--type` option instead.", to: &stderr)
        }

        guard _deprecatedCodeType != nil || _codeType != nil else {
            throw ValidationError("Missing expected argument '--type <swift, objc, colorset, android>'")
        }
    }

    func run() throws {
        let fileType = try FileType(from: inputFilePath.url)

        guard let colorList = fileType.colorListFrom(url: inputFilePath.url) else {
            throw RuntimeError("Could not load \(inputFilePath.string)")
        }

        codeType.generateCode(colorList.colors, directory: outputPath.string)
    }
}
