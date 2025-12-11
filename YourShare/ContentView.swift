//
//  ContentView.swift
//  YourShare
//
//  Created by Simon Skinner on 11/12/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CertificateViewModel()
    @State private var isCheckingAuth = true

    var body: some View {
        ZStack {
            if isCheckingAuth {
                // Splash/Loading screen while checking saved code
                splashScreen
            } else if viewModel.isAuthenticated {
                // Show certificate if authenticated
                CertificateView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                // Show code entry if not authenticated
                CodeEntryView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.isAuthenticated)
        .animation(.easeInOut(duration: 0.3), value: isCheckingAuth)
        .task {
            // Check for saved code on app launch
            _ = await viewModel.checkSavedCode()
            withAnimation {
                isCheckingAuth = false
            }
        }
    }

    private var splashScreen: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Theme.accentGradientVertical)
                    .shadow(color: .teal.opacity(0.3), radius: 10, x: 0, y: 5)

                Text("YourShare")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                    .scaleEffect(1.2)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview {
    ContentView()
}
