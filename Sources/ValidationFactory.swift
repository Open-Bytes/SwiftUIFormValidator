//
//  ValidationPublishers.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Sha. All rights reserved.
//

import Foundation
import Combine

public typealias ValidationPublisher = AnyPublisher<Validation, Never>
public typealias ValidationSubject = PassthroughSubject<Validation, Never>
public typealias DisableValidationClosure = () -> Bool
public typealias OnValidate = (Validation) -> Void

/// Create ValidationContainer object to
/// be passed to validation modifier
public class ValidationFactory {

    /// Create ValidationContainer object to
    /// be passed to validation modifier
    /// - Parameters:
    ///   - form: The FormValidation object
    ///   - validator: The FormValidator concrete class
    ///   - publisher: The root publisher which is validated
    ///   - disableValidation:
    ///   - onValidate: a closure invoked when validation changes
    ///   - setupValidator: apply changes to the validator
    /// - Returns: ValidationContainer
    public static func create<Value, Validator: Validatable>(
            form: FormValidation,
            validator: Validator,
            for publisher: AnyPublisher<Value, Never>,
            disableValidation: @escaping DisableValidationClosure,
            onValidate: OnValidate?
    ) -> ValidationContainer where Validator.Value == Value {
        form.append(ValidatorContainer(validator: validator, disableValidation: disableValidation))
        let pub: ValidationPublisher = publisher.map { value in
                    var val = validator
                    val.value = value
                    let validation = validator.validate()
                    validator.valueChanged(validation)

                    guard !disableValidation() else {
                        return .success
                    }

                    onValidate?(validation)

                    switch form.validationType {
                    case .immediate:
                        return validation
                    case .deferred,
                         .silent:
                        // Send success to simulate deferred validation
                        return .success
                    }
                }
                .dropFirst()
                .eraseToAnyPublisher()
        return ValidationContainer(publisher: pub, subject: validator.subject)
    }

}