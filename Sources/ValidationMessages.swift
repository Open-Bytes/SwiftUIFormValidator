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
    var passwordRegexDescription: String { get }
    var passwordsNotMatching: String { get }
    var anyValidTitle: String? { get }
    func invalidCount(_ count: Int, type: CountValidator.ValidationType) -> String
}

/// All validation messages are included in DefaultValidationMessages, which allows you to easily access
/// and customize any message as needed. By overriding a specific message, you can provide your own
/// custom message for that validation rule, giving you greater control and flexibility
/// over the validation process.
open class DefaultValidationMessages: ValidationMessagesProtocol {
    public init() {
    }

    open var required: String {
        "This field is required."
    }

    open var invalidPattern: String {
        "This field does not match the required format"
    }

    open var invalidEmailAddress: String {
        "The email is not valid"
    }

    open var invalidDate: String {
        "The date is not valid"
    }

    open var passwordRegexDescription: String {
        "Your password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."
    }

    open var passwordsNotMatching: String {
        "The passwords do not match."
    }

    open var anyValidTitle: String? {
        "At least one of the following is required:"
    }

    open func invalidCount(_ count: Int, type: CountValidator.ValidationType) -> String {
        switch type {
        case .equals:
            return "This fields's length must be exactly \(count)."
        case .lessThan:
            return "This fields's length must be < \(count)."
        case .lessThanOrEquals:
            return "This fields's length must be ≤ \(count)."
        case .greaterThan:
            return "This fields's length must be > \(count)."
        case .greaterThanOrEquals:
            return "This fields's length must be ≥ \(count)."
        }
    }

}
