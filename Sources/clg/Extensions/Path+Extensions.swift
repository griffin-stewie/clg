//
//  Path+Extensions.swift
//  clg
//
//  Created by griffin-stewie on 2020/03/09.
//

import Foundation
import ArgumentParser
import Path

extension Path: ExpressibleByArgument {
    public init?(argument: String) {
        self = Path(argument) ?? Path.cwd/argument
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
    init(from path: String) {
        let url = Path(argument: path)!.url
        self = .init(from: url)
    }
}
