//
//  Theme.swift
//  YourShare
//

import SwiftUI

enum Theme {
    // MARK: - Background Colors

    static var backgroundGradientStart: Color {
        Color("BackgroundGradientStart", bundle: nil)
    }

    static var backgroundGradientEnd: Color {
        Color("BackgroundGradientEnd", bundle: nil)
    }

    // Fallback gradient that works in both light and dark mode
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(light: Color(red: 0.95, green: 0.97, blue: 0.98),
                      dark: Color(red: 0.11, green: 0.11, blue: 0.12)),
                Color(light: Color(red: 0.90, green: 0.94, blue: 0.96),
                      dark: Color(red: 0.08, green: 0.08, blue: 0.09))
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Accent Colors

    static var accentGradient: LinearGradient {
        LinearGradient(
            colors: [Color.teal, Color.blue],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static var accentGradientVertical: LinearGradient {
        LinearGradient(
            colors: [Color.teal, Color.blue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Card Styling

    static var cardShadowColor: Color {
        Color.black.opacity(0.08)
    }

    static var cardBorderGradient: LinearGradient {
        LinearGradient(
            colors: [Color.teal.opacity(0.3), Color.blue.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Color Extension for Light/Dark Mode

extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}

// MARK: - Shimmer Effect for Loading States

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (phase * geometry.size.width * 3))
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
