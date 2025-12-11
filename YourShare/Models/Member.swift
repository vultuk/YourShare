//
//  Member.swift
//  YourShare
//

import Foundation

struct Member: Codable, Identifiable {
    let id: UUID
    let code: String
    let name: String
    let shares: Double
    let language: String
}
