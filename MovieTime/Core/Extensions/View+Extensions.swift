//
//  View+Extensions.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 29.12.25.
//

import Foundation
import SwiftUI

extension View {
    func appAlert(error: Binding<AppAlert?>) -> some View {
        alert(
            error.wrappedValue?.alertTitle ?? "Error",
            isPresented: Binding(
                get: { error.wrappedValue != nil },
                set: { if !$0 { error.wrappedValue = nil } }
            )
        ) {
            Button(
                error.wrappedValue?.primaryButtonTitle ?? "OK",
                role: error.wrappedValue?.isDestructive ?? false ? .destructive : nil
            ) {
                error.wrappedValue?.primaryAction?()
                error.wrappedValue = nil
            }

            if let secondaryTitle = error.wrappedValue?.secondaryButtonTitle,
               let secondaryAction = error.wrappedValue?.secondaryAction {
                Button(secondaryTitle, role: .cancel, action: secondaryAction)
            }
        } message: {
            if let message = error.wrappedValue?.alertDescription {
                Text(message)
            }
        }
    }
}
