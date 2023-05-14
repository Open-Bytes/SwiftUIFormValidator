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
public class ValidationPublishers {

    /// Create ValidationContainer object to
    /// be passed to validation modifier
    /// - Parameters:
    ///   - form: The FormValidation object
    ///   - validator: The FormValidator concrete class
    ///   - publisher: The root publisher which is validated
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    public static func create<Validator: FormValidator>(
            form: FormValidation,
            validator: Validator,
            for publisher: AnyPublisher<Validator.Value, Never>,
            disableValidation: @escaping DisableValidationClosure,
            onValidate: OnValidate?
    ) -> ValidationContainer {
        create(form: form,
                validator: validator,
                for: publisher,
                disableValidation: disableValidation,
                onValidate: onValidate
        ) { (value: Validator.Value) in
            var val = validator
            val.value = value
        }
    }

    /// Create ValidationContainer object to
    /// be passed to validation modifier
    /// - Parameters:
    ///   - form: The FormValidation object
    ///   - validator: The FormValidator concrete class
    ///   - publisher: The root publisher which is validated
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    public static func create(
            form: FormValidation,
            validator: StringValidator,
            for publisher: AnyPublisher<String, Never>,
            disableValidation: @escaping DisableValidationClosure,
            onValidate: OnValidate?
    ) -> ValidationContainer {
        create(form: form,
                validator: validator,
                for: publisher,
                disableValidation: disableValidation,
                onValidate: onValidate
        ) { (value: String) in
            var val = validator
            val.value = value
        }
    }

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
    public static func create<Value>(
            form: FormValidation,
            validator: Validatable,
            for publisher: AnyPublisher<Value, Never>,
            disableValidation: @escaping DisableValidationClosure,
            onValidate: OnValidate?,
            setupValidator: @escaping (Value) -> Void
    ) -> ValidationContainer {
        form.append(ValidatorContainer(validator: validator, disableValidation: disableValidation))
        let pub: ValidationPublisher = publisher.map { value in
                    setupValidator(value)
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



