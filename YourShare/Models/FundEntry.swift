//
//  FundEntry.swift
//  YourShare
//

import Foundation

struct FundEntry: Codable, Identifiable {
    let id: Int
    let month: String
    let profitPct: Double
    let feePct: Double
    let withdrawals: Double

    enum CodingKeys: String, CodingKey {
        case id
        case month
        case profitPct = "profit_pct"
        case feePct = "fee_pct"
        case withdrawals
    }
}
