//
//  CalculationEngine.swift
//  YourShare
//

import Foundation

struct CalculationResult {
    let fundTotal: Double
    let sellPrice: Double
    let currentValue: Double
    let percentageGain: Double
    let lastUpdatedMonth: String?
}

enum CalculationEngine {
    /// Calculate the current fund total by iterating through all fund entries
    /// Formula: fund_total = initial_pool, then for each entry:
    ///   profit = fund_total * (profit_pct * (1 - fee_pct))
    ///   fund_total = (fund_total - withdrawals) + profit
    static func calculateFundTotal(initialPool: Double, entries: [FundEntry]) -> Double {
        var fundTotal = initialPool

        for entry in entries {
            let profit = fundTotal * (entry.profitPct * (1 - entry.feePct))
            fundTotal = (fundTotal - entry.withdrawals) + profit
        }

        return fundTotal
    }

    /// Calculate the sell price
    /// Formula: sell_price = fund_total / initial_pool
    static func calculateSellPrice(fundTotal: Double, initialPool: Double) -> Double {
        guard initialPool > 0 else { return 0 }
        return fundTotal / initialPool
    }

    /// Calculate member's current value
    /// Formula: current_value = member.shares * sell_price
    static func calculateCurrentValue(shares: Double, sellPrice: Double) -> Double {
        return shares * sellPrice
    }

    /// Calculate percentage gain
    /// Formula: percentage_gain = (current_value - member.shares) / member.shares
    static func calculatePercentageGain(currentValue: Double, shares: Double) -> Double {
        guard shares > 0 else { return 0 }
        return (currentValue - shares) / shares
    }

    /// Perform all calculations for a member
    static func calculate(member: Member, config: FundConfig, entries: [FundEntry]) -> CalculationResult {
        // Handle edge case: if member.shares = 0
        guard member.shares > 0 else {
            return CalculationResult(
                fundTotal: calculateFundTotal(initialPool: config.initialPool, entries: entries),
                sellPrice: calculateSellPrice(
                    fundTotal: calculateFundTotal(initialPool: config.initialPool, entries: entries),
                    initialPool: config.initialPool
                ),
                currentValue: 0,
                percentageGain: 0,
                lastUpdatedMonth: entries.last?.month
            )
        }

        let fundTotal = calculateFundTotal(initialPool: config.initialPool, entries: entries)
        let sellPrice = calculateSellPrice(fundTotal: fundTotal, initialPool: config.initialPool)
        let currentValue = calculateCurrentValue(shares: member.shares, sellPrice: sellPrice)
        let percentageGain = calculatePercentageGain(currentValue: currentValue, shares: member.shares)

        return CalculationResult(
            fundTotal: fundTotal,
            sellPrice: sellPrice,
            currentValue: currentValue,
            percentageGain: percentageGain,
            lastUpdatedMonth: entries.last?.month
        )
    }
}
