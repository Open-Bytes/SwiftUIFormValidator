//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public typealias StringProducerClosure = () -> String

/// A protocol representing a form validator.
public protocol Validatable {
    func validate() -> Validation

    var errorMessage: StringProducerClosure { get set }

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

public extension Validatable {
    // Default implementation of triggerValidation().
    func triggerValidation() {
        subject.send(validate())
    }
}

/// A protocol representing a form validator.
public protocol FormValidator: Validatable {
    /// The value type of this validator
    associatedtype VALUE
    var value: VALUE { get set }

    /// This functions is called internally to trigger validation.
    ///
    /// - Parameters:
    ///   - value: The value type.
    ///   - errorMessage: The error message.
    /// - Returns: Validation object.
    func validate() -> Validation
}

/// A protocol representing a form validator.
public protocol StringValidator: Validatable {
    /// The value type of this validator
    var value: String { get set }

    /// This functions is called internally to trigger validation.
    ///
    /// - Parameters:
    ///   - value: The value type.
    ///   - errorMessage: The error message.
    /// - Returns: Validation object.
    func validate() -> Validation
}