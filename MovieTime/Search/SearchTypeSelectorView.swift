//
//  SearchTypeSelectorView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI

struct SearchTypeSelectorView: View {
    @Binding var selectedType: SearchType
    let namespace: Namespace.ID

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SearchType.allCases, id: \.self) { type in
                typeButton(for: type)
            }
        }
        .padding(4)
        .background(backgroundCapsule)
        .overlay(borderCapsule)
    }

    // MARK: - Subviews

    private func typeButton(for type: SearchType) -> some View {
        Button {
            handleTypeSelection(type)
        } label: {
            typeButtonLabel(for: type)
        }
    }

    private func typeButtonLabel(for type: SearchType) -> some View {
        ZStack {
            if selectedType == type {
                selectedBackground
            }

            typeText(for: type)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
    }

    private var selectedBackground: some View {
        Capsule()
            .fill(Color.accentRed)
            .matchedGeometryEffect(id: "selectedTab", in: namespace)
            .padding(3)
            .shadow(color: Color.accentRed.opacity(0.5), radius: 8, x: 0, y: 2)
    }

    private func typeText(for type: SearchType) -> some View {
        Text(type.rawValue)
            .font(.subheadline.weight(.medium))
            .foregroundColor(selectedType == type ? .white : .white.opacity(0.6))
    }

    private var backgroundCapsule: some View {
        Capsule()
            .fill(Color.white.opacity(0.05))
    }

    private var borderCapsule: some View {
        Capsule()
            .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
    }

    // MARK: - Actions

    private func handleTypeSelection(_ type: SearchType) {
        withAnimation(
            .interpolatingSpring(
                mass: 0.8,
                stiffness: 200,
                damping: 15,
                initialVelocity: 5
            )
        ) {
            selectedType = type
        }
    }
}
