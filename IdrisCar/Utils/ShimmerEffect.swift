//
//  ShimmerEffect.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 10/09/2026.
//

import SwiftUI

@available(iOS 15.0, *)
struct ShimmerEffectBox: View {
    @State private var startPoint = UnitPoint(x: -1.8, y: -1.2)
    @State private var endPoint = UnitPoint(x: 0, y: -0.2)
    var speed: CGFloat
    var colors: [Color]
    
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint)
        .onAppear(perform: loopAnimation)
    }
    
    private func loopAnimation() {
        withAnimation(
            .easeInOut(duration: speed)
            .repeatForever(autoreverses: false)
        ) {
            startPoint = .init(x: 1, y: 1)
            endPoint = .init(x: 2.2, y: 2.2)
        }
    }
}

@available(iOS 15.0, *)
struct ShimmerModifier: ViewModifier {
    private var isActive: Bool
    private var speed: CGFloat
    private var colors: [Color] = [
        Color(uiColor: .systemGray5),
        Color(uiColor: .systemGray6),
        Color(uiColor: .systemGray5)]
    private var cornerRadius: CGFloat
    
    init(
        isActive: Bool,
        speed: CGFloat,
        colors: [Color],
        cornerRadius: CGFloat
    ) {
        self.isActive = isActive
        self.speed = speed
        self.cornerRadius = cornerRadius
        if !colors.isEmpty {
            self.colors = colors
        }
    }
    
    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay {
                    ShimmerEffectBox(
                        speed: speed,
                        colors: colors
                    ).cornerRadius(cornerRadius)
                }
        } else {
            content
        }
    }
}

@available(iOS 15.0, *)
public extension View {
    /// Applies a shimmer effect to the view.
    ///
    /// - Parameters:
    ///   - isActive: A flag indicating whether the shimmer effect is active.
    ///   - speed: The speed of the shimmer animation.
    ///   - colors: An array of colors used in the shimmer animation.
    ///   - cornerRadius: The corner radius of the shimmering view.
    ///
    /// - Returns: A view with the applied shimmer effect.
    func shimmerEffect(
        isActive: Bool,
        speed: CGFloat = 1,
        colors: [Color] = [],
        cornerRadius: CGFloat = 5
    ) -> some View {
        modifier(ShimmerModifier(
            isActive: isActive,
            speed: speed,
            colors: colors,
            cornerRadius: cornerRadius)
        )
    }
    
    /// Applies a simple shimmer effect to the view.
    ///
    /// - Parameters:
    ///   - isActive: A flag indicating whether the shimmer effect is active.
    ///
    /// - Returns: A view with the applied shimmer effect.
    func shimmer(_ isActive: Bool) -> some View {
        modifier(ShimmerModifier(
            isActive: isActive,
            speed: 1,
            colors: [],
            cornerRadius: 5)
        )
    }
}

struct ShimmerSkeletonBlock: View {
    var width: CGFloat?
    var height: CGFloat
    var cornerRadius: CGFloat = 6
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(uiColor: .systemGray5))
            .frame(width: width, height: height)
            .shimmerEffect(isActive: true, cornerRadius: cornerRadius)
    }
}

struct ShimmerSkeletonLine: View {
    var width: CGFloat
    var height: CGFloat = 14
    
    var body: some View {
        ShimmerSkeletonBlock(width: width, height: height, cornerRadius: height / 2)
    }
}
