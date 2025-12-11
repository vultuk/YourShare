//
//  Member.swift
//  YourShare
//

import Foundation

struct Member: Codable, Identifiable {
    let id: Int
    let code: String
    let name: String
    let shares: Double
    let language: String

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case name
        case shares
        case language
    }
}
