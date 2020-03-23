//
//  CLRCommand.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/08.
//

import Foundation
import ArgumentParser
import Path
import Core

struct CLRCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "clr",
        abstract: "generates clr file from input"
    )

    @Option(name: [.customLong("output"), .customShort("o")], default: Path.home/"Library"/"Colors", help: "Output directory that clr file will be saved.")
    var outputPath: Path

    @Argument(help: ArgumentHelp("Supported file types are \(FileType.allCasesDescription)", valueName: "input file"))
    var inputFilePath: Path

    func run() throws {
        // Detect what file type `inputFile` is
        let fileType = try FileType(from: inputFilePath.url)

        guard let colorList = fileType.colorListFrom(url: inputFilePath.url) else {
            throw RuntimeError("Could not load \(inputFilePath.string)")
        }

        // save
        let filePath = outputPath/"\(inputFilePath.basename(dropExtension: true)).clr"

        try colorList.write(to: filePath.url)
    }
}
