//
//  SupabaseConfig.swift
//  YourShare
//

import Foundation

enum SupabaseConfig {
    // These values should be configured via environment or Info.plist
    // For now, they can be set here or loaded from configuration
    static var projectURL: String {
        // Try to load from Info.plist first
        if let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String, !url.isEmpty {
            return url
        }
        // Fallback to environment variable or default
        return ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? ""
    }

    static var anonKey: String {
        // Try to load from Info.plist first
        if let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String, !key.isEmpty {
            return key
        }
        // Fallback to environment variable or default
        return ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"] ?? ""
    }

    static var baseURL: URL? {
        guard !projectURL.isEmpty else { return nil }
        return URL(string: "\(projectURL)/rest/v1")
    }
}
