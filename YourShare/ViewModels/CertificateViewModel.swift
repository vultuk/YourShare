//
//  CertificateViewModel.swift
//  YourShare
//

import Combine
import Foundation
import SwiftUI

@MainActor
class CertificateViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var member: Member?
    @Published var calculationResult: CalculationResult?

    // MARK: - Private Properties

    private let supabaseService = SupabaseService.shared

    // MARK: - Computed Properties

    var isAuthenticated: Bool {
        member != nil
    }

    var localizedStrings: LocalizedStrings {
        LocalizedStrings(languageCode: member?.language ?? "en")
    }

    var formattedCurrentValue: String {
        guard let result = calculationResult else { return "£0.00" }
        return LocalizedStrings.formatCurrency(result.currentValue)
    }

    var formattedPercentageGain: String {
        guard let result = calculationResult else { return "0.0%" }
        return LocalizedStrings.formatPercentage(result.percentageGain)
    }

    var formattedLastUpdated: String {
        guard let month = calculationResult?.lastUpdatedMonth else { return "" }
        return localizedStrings.formatMonth(month)
    }

    // MARK: - UserDefaults

    private static let memberCodeKey = "memberCode"

    var savedMemberCode: String? {
        UserDefaults.standard.string(forKey: Self.memberCodeKey)
    }

    private func saveMemberCode(_ code: String) {
        UserDefaults.standard.set(code.lowercased(), forKey: Self.memberCodeKey)
    }

    func clearMemberCode() {
        UserDefaults.standard.removeObject(forKey: Self.memberCodeKey)
        member = nil
        calculationResult = nil
    }

    // MARK: - Data Loading

    func loadMember(withCode code: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedMember = try await supabaseService.fetchMember(byCode: code)
            member = fetchedMember
            saveMemberCode(code)

            // Now load fund data and calculate
            await loadFundData()

            isLoading = false
            return true
        } catch let error as SupabaseError {
            isLoading = false
            errorMessage = error.errorDescription
            return false
        } catch {
            isLoading = false
            errorMessage = "An unexpected error occurred"
            return false
        }
    }

    func loadFundData() async {
        guard let member = member else { return }

        isLoading = true
        errorMessage = nil

        do {
            async let configTask = supabaseService.fetchFundConfig()
            async let entriesTask = supabaseService.fetchFundEntries()

            let (config, entries) = try await (configTask, entriesTask)

            calculationResult = CalculationEngine.calculate(
                member: member,
                config: config,
                entries: entries
            )

            isLoading = false
        } catch let error as SupabaseError {
            isLoading = false
            errorMessage = error.errorDescription
        } catch {
            isLoading = false
            errorMessage = "An unexpected error occurred"
        }
    }

    func refresh() async {
        if let code = savedMemberCode {
            _ = await loadMember(withCode: code)
        }
    }

    /// Check if there's a saved code and try to auto-login
    func checkSavedCode() async -> Bool {
        guard let code = savedMemberCode else {
            return false
        }
        return await loadMember(withCode: code)
    }
}
