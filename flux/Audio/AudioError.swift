//
//  AudioError.swift
//  flux
//
//  Created by Xavier Chen on 27/1/26.
//

import Foundation

enum AudioError: LocalizedError {
    case permissionDenied
    case sessionActivationFailed
    case sessionDeActivationFailed
    case engineError

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Microphone Access Required"
        case .sessionActivationFailed:
            return "Session Activation Error"
        case .sessionDeActivationFailed:
            return "Session DeActivation Error"
        case .engineError:
            return "Engine Error"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .permissionDenied:
            return
                "Please enable microphone access in Settings. This app needs to listen to the environment."
        case .sessionActivationFailed:
            return
                "Could not activate the audio session. Please restart the app."
        case .sessionDeActivationFailed:
            return
                "Could not deactivate the audio session. Please restart the app."
        case .engineError:
            return "Could not setup audio engine. Please restart the app."
        }
    }
}
