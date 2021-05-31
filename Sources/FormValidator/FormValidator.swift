//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public typealias StringProducerClosure = () -> String

/// A protocol representing a form validator.
public protocol FormValidatorProtocol {
    /// The latest triggered validation.
    var latestValidation: Validation { get set }

    // The root published whose value is validated.
    // For example: when the used edits the value of a TextFiled,
    // the validation is triggered.
    var publisher: ValidationPublisher! { get set }

    // A subject used for manually triggering the validation.
    var subject: ValidationSubject { get set }

    /// This callback is called when a validation is triggered.
    /// Don't provide a closure because it's used internally.
    var onChanged: ((Validation) -> Void)? { get set }

    /// Calls the subject to manually trigger validation.
    func triggerValidation()
}

/// A protocol representing a form validator.
public protocol FormValidator: FormValidatorProtocol {
    /// The value type of this validator
    associatedtype VALUE

    /// This functions is called internally to trigger validation.
    ///
    /// - Parameters:
    ///   - value: The value type.
    ///   - errorMessage: The error message.
    /// - Returns: Validation object.
    func validate(value: VALUE, errorMessage: @autoclosure @escaping StringProducerClosure) -> Validation
}

public extension FormValidator {
    // Default implementation of triggerValidation().
    func triggerValidation() {
        subject.send(latestValidation)
    }
}