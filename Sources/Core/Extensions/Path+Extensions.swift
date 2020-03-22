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

public extension URL {
    func basename(dropExtension: Bool) -> String {
        guard let p = Path(url: self) else {
            preconditionFailure("file URL expected")
        }

        return p.basename(dropExtension: dropExtension)
    }
}

public extension FileType {
    init(from path: String) {
        let url = Path(argument: path)!.url
        self = .init(from: url)
    }
}

public extension ASE {
    init(from path: Path) throws {
        try self.init(from: path.url)
    }
}

public extension CSVParser {
    func parse(path: Path) -> NSColorList? {
        return parse(path.string)
    }
}
