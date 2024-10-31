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
    ///   - manager: The FormValidation object
    ///   - validator: The FormValidator concrete class
    ///   - publisher: The root publisher which is validated
    ///   - disableValidation:
    ///   - onValidate: a closure invoked when validation changes
    ///   - setupValidator: apply changes to the validator
    /// - Returns: ValidationContainer
    public static func create<Value: Equatable, Validator: Validatable>(
            manager: FormManager,
            validator: Validator,
            for publisher: AnyPublisher<Value, Never>,
            disableValidation: @escaping DisableValidationClosure,
            onValidate: OnValidate?
    ) -> ValidationContainer where Validator.Value == Value {
        manager.append(ValidatorContainer(validator: validator, disableValidation: disableValidation))
        let pub: ValidationPublisher = publisher
            .removeDuplicates()
            .map { value in
                    var val = validator

                    let lastValue = val.value
                    let lastValidation = val.validate()

                    val.value = value
                    let validation = validator.validate()
                    validator.valueChanged(validation)

                    guard !disableValidation() else {
                        return .success
                    }

                    if val.value != lastValue, validation != lastValidation {
                        onValidate?(validation)
                    }

                    switch manager.validationType {
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
        return ValidationContainer(
                validator: validator,
                publisher: pub,
                subject: validator.subject)
    }

}
