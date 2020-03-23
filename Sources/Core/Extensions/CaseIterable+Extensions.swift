//
//  CaseIterable+Extensions.swift
//  Core
//
//  Created by griffin-stewie on 2020/03/23.
//  
//

import Foundation

extension CaseIterable {
    public static var allCasesDescription: String {
        return self.allCases.map{String(describing: $0)}.joined(separator: ", ")
    }
}
