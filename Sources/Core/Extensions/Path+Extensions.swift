//
//  Path+Extensions.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/09.
//

import Cocoa
import Foundation
import ArgumentParser
import Path
import ASE

extension Path: ExpressibleByArgument {
    public init?(argument: String) {
        self = Path(argument) ?? Path.cwd/argument
    }

    public var defaultValueDescription: String {
        if self == Path.cwd/"." {
            return "current directory"
        }

        return String(describing: self)
    }
}

extension URL {
    func basename(dropExtension: Bool) -> String {
        guard let p = Path(url: self) else {
            preconditionFailure("file URL expected")
        }

        return p.basename(dropExtension: dropExtension)
    }
}

extension FileType {
    init(from path: String) throws {
        let url = Path(argument: path)!.url
        self = try .init(from: url)
    }
}

extension ASE {
    init(from path: Path) throws {
        try self.init(from: path.url)
    }
}

extension CSVParser {
    func parse(path: Path) -> NSColorList? {
        return parse(path.string)
    }
}
