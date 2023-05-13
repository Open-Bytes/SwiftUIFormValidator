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
    public static func create<VALIDATOR: FormValidator>(
            form: FormValidation,
            validator: VALIDATOR,
            for publisher: AnyPublisher<VALIDATOR.VALUE, Never>,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate?
    ) -> ValidationContainer {
        create(form: form,
                validator: validator,
                for: publisher,
                disableValidation: disableValidation,
                onValidate: onValidate
        ) { (value: VALIDATOR.VALUE) in
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
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
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
    public static func create<VALUE>(
            form: FormValidation,
            validator: Validatable,
            for publisher: AnyPublisher<VALUE, Never>,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate?,
            setupValidator: @escaping (VALUE) -> Void
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

    public static func create(
            form: FormValidation,
            validators: [StringValidator],
            type: CompositeValidator.ValidationType,
            for publisher: AnyPublisher<String, Never>,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate?
    ) -> ValidationContainer {
        let compositeValidator = CompositeValidator(validators: validators, type: type)
        form.append(ValidatorContainer(validator: compositeValidator, disableValidation: disableValidation))
        let pub: ValidationPublisher = publisher.map { value in
                    compositeValidator.value = value
                    let validation = compositeValidator.validate()

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
        let subject = ValidationSubject()

        // Send each validator's subject value to our subject
        // to notify the view with the validation
        switch form.validationType {
        case .immediate:
            for var validator in validators {
                validator.observeChange { value in
                    subject.send(value)
                }
            }
        case .deferred,
             .silent:
            break
        }
        return ValidationContainer(publisher: pub, subject: subject)
    }

}



