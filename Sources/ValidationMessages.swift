//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public protocol ValidationMessagesProtocol {
    var required: String { get }
    var invalidPattern: String { get }
    var invalidEmailAddress: String { get }
    var invalidDate: String { get }
    var passwordsNotMatching: String { get }
    func invalidCount(_ count: Int, type: CountValidator.ValidationType) -> String
}

open class DefaultValidationMessages: ValidationMessagesProtocol {
    public init() {
    }

    open var required: String {
        "Required"
    }

    open var invalidPattern: String {
        "Invalid pattern"
    }

    open var invalidEmailAddress: String {
        "Invalid email address"
    }

    open var invalidDate: String {
        "Invalid date"
    }

    open var passwordsNotMatching: String {
        "Passwords don't match"
    }

    open func invalidCount(_ count: Int, type: CountValidator.ValidationType) -> String {
        switch type {
        case .equals:
            return "Must equal \(count)"
        case .lessThan:
            return "Must be less than \(count)"
        case .lessThanOrEquals:
            return "Must be less than or equal to \(count)"
        case .greaterThan:
            return "Must be greater than \(count)"
        case .greaterThanOrEquals:
            return "Must be greater than or equal to \(count)"
        }
    }

}
