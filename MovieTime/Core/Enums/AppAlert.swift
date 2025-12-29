//
//  AppAlert.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 29.12.25.
//
import SwiftUI

enum AppAlert: LocalizedError, Identifiable {
    case confirmation(
        title: String,
        message: String?,
        confirmTitle: String,
        confirmAction: (() -> Void)?,
        cancelTitle: String = "Cancel",
        secondaryAction: (() -> Void)? = nil,
        isPrimaryActionDestructive: Bool = false
    )
    case info(
        title: String,
        message: String?,
        dismissTitle: String = "OK",
        dismissAction: (() -> Void)? = nil
    )

    var id: String { localizedDescription } // Identifiable for SwiftUI binding

    var alertTitle: String? {
        switch self {
        case .confirmation(let title, _, _, _, _, _, _),
             .info(let title, _, _, _):
            return title
        }
    }

    var alertDescription: String? {
        switch self {
        case .confirmation(_, let message, _, _, _, _, _),
             .info(_, let message, _, _):
            return message
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .confirmation(_, _, let confirmTitle, _, _, _, _):
            return confirmTitle
        case .info(_, _, let dismissTitle, _):
            return dismissTitle
        }
    }

    var primaryAction: (() -> Void)? {
        switch self {
        case .confirmation(_, _, _, let confirmAction, _, _, _):
            return confirmAction
        case .info(_, _, _, let dismissAction):
            return dismissAction
        }
    }

    var secondaryButtonTitle: String? {
        switch self {
        case .confirmation(_, _, _, _, let cancelTitle, _, _):
            return cancelTitle
        case .info:
            return nil // No secondary button for info alerts
        }
    }

    var secondaryAction: (() -> Void)? {
        switch self {
        case .confirmation(_, _, _, _, _, let secondaryAction, _):
            return secondaryAction
        case .info:
            return nil // No secondary action for info alerts
        }
    }
    
    var isDestructive: Bool {
        switch self {
        case .confirmation(_, _, _, _, _, _, let isDestructive):
            return isDestructive
        default:
            return false
        }
    }
}
