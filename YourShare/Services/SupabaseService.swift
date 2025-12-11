//
//  SupabaseService.swift
//  YourShare
//

import Foundation

enum SupabaseError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case notFound
    case missingConfiguration

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Data error: \(error.localizedDescription)"
        case .notFound:
            return "Code not found"
        case .missingConfiguration:
            return "Supabase configuration is missing"
        }
    }
}

actor SupabaseService {
    static let shared = SupabaseService()

    private init() {}

    private func makeRequest(endpoint: String, query: String = "") async throws -> Data {
        guard let baseURL = SupabaseConfig.baseURL else {
            throw SupabaseError.missingConfiguration
        }

        var urlString = "\(baseURL)/\(endpoint)"
        if !query.isEmpty {
            urlString += "?\(query)"
        }

        guard let url = URL(string: urlString) else {
            throw SupabaseError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            return data
        } catch {
            throw SupabaseError.networkError(error)
        }
    }

    func fetchMember(byCode code: String) async throws -> Member {
        let query = "code=ilike.\(code.lowercased())&limit=1"
        let data = try await makeRequest(endpoint: "members", query: query)

        do {
            let members = try JSONDecoder().decode([Member].self, from: data)
            guard let member = members.first else {
                throw SupabaseError.notFound
            }
            return member
        } catch is SupabaseError {
            throw SupabaseError.notFound
        } catch {
            throw SupabaseError.decodingError(error)
        }
    }

    func fetchFundConfig() async throws -> FundConfig {
        let query = "limit=1"
        let data = try await makeRequest(endpoint: "fund_config", query: query)

        do {
            let configs = try JSONDecoder().decode([FundConfig].self, from: data)
            guard let config = configs.first else {
                throw SupabaseError.notFound
            }
            return config
        } catch is SupabaseError {
            throw SupabaseError.notFound
        } catch {
            throw SupabaseError.decodingError(error)
        }
    }

    func fetchFundEntries() async throws -> [FundEntry] {
        let query = "order=month.asc"
        let data = try await makeRequest(endpoint: "fund_entries", query: query)

        do {
            return try JSONDecoder().decode([FundEntry].self, from: data)
        } catch {
            throw SupabaseError.decodingError(error)
        }
    }
}
