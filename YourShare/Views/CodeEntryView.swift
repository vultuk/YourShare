//
//  CodeEntryView.swift
//  YourShare
//

import SwiftUI

struct CodeEntryView: View {
    @ObservedObject var viewModel: CertificateViewModel
    @State private var code: String = ""
    @State private var showError: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            // Background gradient
            Theme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Logo/Header
                VStack(spacing: 16) {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.teal, Color.blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .teal.opacity(0.3), radius: 10, x: 0, y: 5)

                    Text("YourShare")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.primary, Color.primary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("View your investment certificate")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Input Card
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter your member code")
                            .font(.headline)
                            .foregroundColor(.primary)

                        TextField("Member code", text: $code)
                            .textFieldStyle(.plain)
                            .font(.title3)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(showError ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                submitCode()
                            }

                        // Error message
                        if showError {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text("Code not found")
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }

                    Button(action: submitCode) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                            } else {
                                Text("View Certificate")
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.right")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: code.isEmpty ? [Color.gray] : [Color.teal, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(code.isEmpty || viewModel.isLoading)
                    .animation(.easeInOut(duration: 0.2), value: code.isEmpty)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal)

                Spacer()
                Spacer()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showError)
    }

    private func submitCode() {
        guard !code.isEmpty else { return }

        isTextFieldFocused = false
        showError = false

        Task {
            let success = await viewModel.loadMember(withCode: code)
            if !success {
                withAnimation {
                    showError = true
                }
            }
        }
    }
}

#Preview {
    CodeEntryView(viewModel: CertificateViewModel())
}
