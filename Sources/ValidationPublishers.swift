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

/// Create ValidationContainer object to
/// be passed to validation modifier
public class ValidationPublishers {

    /// Create ValidationContainer object to
    /// be passed to validation modifier
    /// - Parameters:
    ///   - form: The FormValidation object
    ///   - validator: The FormValidator concrete class
    ///   - publisher: The root publisher which is validated
    ///   - errorMessage: The error string
    /// - Returns: ValidationContainer
    public static func create<VALIDATOR: FormValidator>(
            form: FormValidation,
            validator: VALIDATOR,
            for publisher: AnyPublisher<VALIDATOR.VALUE, Never>,
            errorMessage: @autoclosure @escaping StringProducerClosure
    ) -> ValidationContainer {
        create(form: form,
                validator: validator,
                for: publisher,
                errorMessage: errorMessage()
        ) {
            (value: VALIDATOR.VALUE) in
            var val = validator
            val.errorMessage = errorMessage
            val.value = value
        }
    }

    /// Create ValidationContainer object to
    /// be passed to validation modifier
    /// - Parameters:
    ///   - form: The FormValidation object
    ///   - validator: The FormValidator concrete class
    ///   - publisher: The root publisher which is validated
    ///   - errorMessage: The error string
    /// - Returns: ValidationContainer
    public static func create(
            form: FormValidation,
            validator: StringValidator,
            for publisher: AnyPublisher<String, Never>,
            errorMessage: @autoclosure @escaping StringProducerClosure
    ) -> ValidationContainer {
        create(form: form,
                validator: validator,
                for: publisher,
                errorMessage: errorMessage()
        ) {
            (value: String) in
            var val = validator
            val.errorMessage = errorMessage
            val.value = value
        }
    }

    /// Create ValidationContainer object to
    /// be passed to validation modifier
    /// - Parameters:
    ///   - form: The FormValidation object
    ///   - validator: The FormValidator concrete class
    ///   - publisher: The root publisher which is validated
    ///   - errorMessage: The error string
    /// - Returns: ValidationContainer
    public static func create<VALUE>(
            form: FormValidation,
            validator: Validatable,
            for publisher: AnyPublisher<VALUE, Never>,
            errorMessage: @autoclosure @escaping StringProducerClosure,
            setupValidator: @escaping (VALUE) -> Void
    ) -> ValidationContainer {
        form.append(validator)
        let pub: ValidationPublisher = publisher.map { value in
                    setupValidator(value)
                    let validation = validator.validate()
                    validator.onChanged?(validation)

                    switch form.validationType {
                    case .immediate:
                        return validation
                    case .deferred:
                        // Send success to simulate deferred validation
                        return .success
                    }
                }.dropFirst()
                .eraseToAnyPublisher()
        return ValidationContainer(publisher: pub, subject: validator.subject)
    }

    public static func create(
            form: FormValidation,
            validators: [StringValidator],
            type: CompositeValidator.ValidationType,
            for publisher: AnyPublisher<String, Never>,
            errorMessage: @autoclosure @escaping StringProducerClosure
    ) -> ValidationContainer {
        validators.forEach {
            form.append($0)
        }
        let compositeValidator = CompositeValidator()
        let pub: ValidationPublisher = publisher.map { value in
                    let validation = compositeValidator.validate(
                            value: value,
                            validators: validators,
                            type: type,
                            errorMessage: errorMessage())

                    switch form.validationType {
                    case .immediate:
                        return validation
                    case .deferred:
                        // Send success to simulate deferred validation
                        return .success
                    }
                }.dropFirst()
                .eraseToAnyPublisher()
        return ValidationContainer(publisher: pub, subject: .init())
    }
}



