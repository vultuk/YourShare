//
//  Localization.swift
//  YourShare
//

import Foundation

enum AppLanguage: String {
    case english = "en"
    case hungarian = "hu"
}

struct LocalizedStrings {
    let language: AppLanguage

    init(languageCode: String) {
        self.language = AppLanguage(rawValue: languageCode.lowercased()) ?? .english
    }

    var currentValue: String {
        switch language {
        case .english:
            return "Current Value"
        case .hungarian:
            return "Jelenlegi érték"
        }
    }

    var sinceInvestment: String {
        switch language {
        case .english:
            return "since investment"
        case .hungarian:
            return "befektetés óta"
        }
    }

    var lastUpdated: String {
        switch language {
        case .english:
            return "Last updated"
        case .hungarian:
            return "Utolsó frissítés"
        }
    }

    var changeCode: String {
        switch language {
        case .english:
            return "Change code"
        case .hungarian:
            return "Kód módosítása"
        }
    }

    var refresh: String {
        switch language {
        case .english:
            return "Refresh"
        case .hungarian:
            return "Frissítés"
        }
    }

    /// Format a month string (e.g., "2025-11") to a localized month name
    func formatMonth(_ monthString: String) -> String {
        // Parse the month string (expected format: "YYYY-MM")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"

        guard let date = dateFormatter.date(from: monthString) else {
            return monthString
        }

        switch language {
        case .english:
            // UK format: "November 2025"
            dateFormatter.dateFormat = "MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "en_GB")
        case .hungarian:
            // Hungarian format: "2025. november"
            dateFormatter.dateFormat = "yyyy. MMMM"
            dateFormatter.locale = Locale(identifier: "hu_HU")
        }

        return dateFormatter.string(from: date)
    }
}

extension LocalizedStrings {
    /// Format currency in GBP
    static func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "GBP"
        formatter.currencySymbol = "£"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: NSNumber(value: value)) ?? "£0.00"
    }

    /// Format percentage with one decimal place
    static func formatPercentage(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 100
        return formatter.string(from: NSNumber(value: value)) ?? "0.0%"
    }
}
