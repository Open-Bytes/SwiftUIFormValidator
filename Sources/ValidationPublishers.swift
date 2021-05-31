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
        form.append(validator)
        let pub: ValidationPublisher = publisher.map { value in
                    let validation = validator.validate(value: value, errorMessage: errorMessage())
                    var val = validator
                    val.latestValidation = validation
                    val.onChanged?(val.latestValidation)

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
}



