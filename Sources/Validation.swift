//
//  Validation.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import Foundation

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
