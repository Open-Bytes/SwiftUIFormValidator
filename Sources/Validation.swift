//
//  Validation.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Sha. All rights reserved.
//

import Foundation

/// This enum represents the validation result
public enum Validation {
    case success
    case failure(message: String)

    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
}
