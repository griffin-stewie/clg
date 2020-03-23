//
//  FileDetector.swift
//  ColorListGenerator
//
//  Created by griffin-stewie on 2015/06/23.
//  Copyright (c) 2015 net.cyan-stivy. All rights reserved.
//

import Foundation
import Cocoa
import Path
import ASE

public enum FileType: CaseIterable {
    case clr;
    case json;
    case ase;
    case csv;
}

public extension FileType {

    init(from url: URL) throws {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "clr":
            self = .clr
        case "ase":
            self = .ase
        case "json":
            self = .json
        case "csv":
            self = .csv
        case "txt":
            self = .csv
        default:
            throw RuntimeError("Unsupported file types. Supported file types are \(FileType.allCasesDescription).")
        }
    }

    func colorListFrom(url: URL) -> NSColorList? {
        switch self {
        case .clr:
            return NSColorList(name: url.basename(dropExtension: true), fromFile: url.path)
        case .json:
            do {
                let paletteName = url.basename(dropExtension: true)
                let jsonData = try Data(contentsOf: url)

                guard let colorDicts = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [[String:String]] else {
                    return nil
                }

                print(colorDicts.description)

                let colors: [Color] = colorDicts.map{ Color(dictionary: $0) }
                let colorList = NSColorList(name: paletteName)
                for color in colors {
                    colorList.setColor(color.color, forKey: color.name)
                }
                return colorList
            } catch {
                return nil
            }

        case .ase:
            let ase = try? ASE(from: url)
            return ase?.colorList
        case .csv:
            guard let text = try? String(contentsOf: url, encoding: .utf8) else {
                return nil
            }
            return CSVParser().parse(text)
        default:
            preconditionFailure("Unsupported file")
        }
    }
}

extension FileHandle : TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}
