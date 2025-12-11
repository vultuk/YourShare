//
//  FundConfig.swift
//  YourShare
//

import Foundation

struct FundConfig: Codable, Identifiable {
    let key: String
    let value: Double

    var id: String { key }

    var initialPool: Double { value }

    enum CodingKeys: String, CodingKey {
        case key
        case value
    }
}
