//
//  CertificateView.swift
//  YourShare
//

import SwiftUI

struct CertificateView: View {
    @ObservedObject var viewModel: CertificateViewModel
    @State private var isRefreshing = false
    @State private var showChangeCodeAlert = false

    private var strings: LocalizedStrings {
        viewModel.localizedStrings
    }

    var body: some View {
        ZStack {
            // Background
            backgroundGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header with name
                    headerSection

                    // Certificate Card
                    certificateCard

                    // Action buttons
                    actionButtons

                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            .refreshable {
                await viewModel.refresh()
            }

            // Loading overlay
            if viewModel.isLoading && !isRefreshing {
                loadingOverlay
            }
        }
        .alert("Change code?", isPresented: $showChangeCodeAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Change", role: .destructive) {
                withAnimation {
                    viewModel.clearMemberCode()
                }
            }
        } message: {
            Text("This will sign you out and return to the code entry screen.")
        }
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        Theme.backgroundGradient
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(viewModel.member?.name ?? "")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text("Investment Certificate")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }

    // MARK: - Certificate Card

    private var certificateCard: some View {
        VStack(spacing: 0) {
            // Main value section
            VStack(spacing: 8) {
                Text(strings.currentValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)

                Text(viewModel.formattedCurrentValue)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.teal, Color.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .contentTransition(.numericText())
            }
            .padding(.vertical, 32)

            Divider()
                .padding(.horizontal)

            // Percentage gain section
            VStack(spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.green)

                    Text(viewModel.formattedPercentageGain)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                }

                Text(strings.sinceInvestment)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 24)

            Divider()
                .padding(.horizontal)

            // Last updated section
            if !viewModel.formattedLastUpdated.isEmpty {
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("\(strings.lastUpdated): \(viewModel.formattedLastUpdated)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [Color.teal.opacity(0.3), Color.blue.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Refresh button
            Button(action: {
                Task {
                    isRefreshing = true
                    await viewModel.refresh()
                    isRefreshing = false
                }
            }) {
                HStack {
                    if isRefreshing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                    Text(strings.refresh)
                }
                .font(.headline)
                .foregroundColor(.teal)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.teal.opacity(0.1))
                )
            }
            .disabled(isRefreshing)

            // Change code button
            Button(action: {
                showChangeCodeAlert = true
            }) {
                HStack {
                    Image(systemName: "arrow.uturn.left")
                    Text(strings.changeCode)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Loading Overlay

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                    .scaleEffect(1.5)

                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 10)
            )
        }
    }
}

#Preview {
    let viewModel = CertificateViewModel()
    return CertificateView(viewModel: viewModel)
}
