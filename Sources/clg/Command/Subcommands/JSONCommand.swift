//
//  JSONCommand.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/08.
//

import Cocoa
import Foundation
import ArgumentParser
import Path
import Core

struct JSONCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "json",
        abstract: """
        generates JSON from clr file OR CSV file OR ASE file a.k.a. "Adobe Swatch Exchange"
        """
    )

    @Option(name: [.customLong("output"), .customShort("o")], help: ArgumentHelp("Output JSON file path. (default: current directory)", valueName: "directory"))
    var _outputPath: Path?

    var outputPath: Path {
        _outputPath ?? Path.cwd/"."
    }

    @Argument()
    var inputFilePath: Path

    func run() throws {
        // Detect what file type `inputFile` is
        let fileType = FileType(from: inputFilePath.url)

        // convert input file to NSColorList
        guard let colorList = fileType.colorListFrom(url: inputFilePath.url) else {
            throw RuntimeError("Could not load \(inputFilePath.string)")
        }

        // convert NSColorList to JSON
        guard let data = colorList.toJSONData() else {
            throw RuntimeError("Could not convert to JSON")
        }

        // save
        let palletName = inputFilePath.basename(dropExtension: true)
        let outputFilePath = outputPath(from: outputPath, filename: palletName)
        try data.write(to: outputFilePath)
    }
}

fileprivate extension JSONCommand {
    func outputPath(from path: Path, filename: String) -> Path {
        guard path.isFile else {
            return Path.cwd/"\(filename).json"
        }

        return path
    }
}
