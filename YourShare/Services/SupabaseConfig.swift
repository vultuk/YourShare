//
//  SupabaseConfig.swift
//  YourShare
//

import Foundation

enum SupabaseConfig {
    static let projectURL = "https://lmtwvioutznspggclasv.supabase.co"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdHd2aW91dHpuc3BnZ2NsYXN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NDQyNTMsImV4cCI6MjA4MTAyMDI1M30.ZQ2Q6d-Bnn5oNW2VasZlrsUoq21gwWXE9n2mhpmt1TQ"

    static var baseURL: URL? {
        URL(string: "\(projectURL)/rest/v1")
    }
}
