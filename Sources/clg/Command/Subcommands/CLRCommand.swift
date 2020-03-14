//
//  CLRCommand.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/08.
//

import Foundation
import ArgumentParser
import Path

struct CLRCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "clr",
        abstract: "generates clr file from JSON"
    )

    @Option(name: [.customLong("output"), .customShort("o")], default: Path.home/"Library"/"Colors", help: "Output directory that clr file will be saved.")
    var outputPath: Path

    @Argument()
    var inputFilePath: Path

    func run() throws {
        guard let colorList = FileType.json.colorListFrom(url: inputFilePath.url) else {
            throw RuntimeError("Could not load \(inputFilePath.string)")
        }

        // save
        let filePath = outputPath/"\(inputFilePath.basename(dropExtension: true)).clr"

        try colorList.write(to: filePath.url)
    }
}
