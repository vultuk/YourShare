//
//  FundConfig.swift
//  YourShare
//

import Foundation

struct FundConfig: Codable, Identifiable {
    let id: Int
    let initialPool: Double

    enum CodingKeys: String, CodingKey {
        case id
        case initialPool = "initial_pool"
    }
}
