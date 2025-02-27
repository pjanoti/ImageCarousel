//
//  ScrollOffsetTracker.swift
//  ImageCarousel
//
//  Created by prema janoti on 27/02/25.
//


import SwiftUI

struct ScrollOffsetTracker: View {
    @Binding var isPinned: Bool
    @State private var previousScrollOffset: CGFloat = 0
    @State private var isScrollingUp = false

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .global).minY)
        }
        .onPreferenceChange(ScrollOffsetKey.self) { newValue in
            let diff = newValue - previousScrollOffset
            isScrollingUp = diff < 0

            if isScrollingUp {
                isPinned = true
            } else {
                isPinned = false
            }

            previousScrollOffset = newValue
        }
    }
}


// MARK: - Preference Keys

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

