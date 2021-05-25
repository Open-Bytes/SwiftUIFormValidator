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

public class ValidationPublishers {

    public static func create<VALIDATOR: FormValidator>(
            form: FormValidation,
            validator: VALIDATOR,
            for publisher: Published<VALIDATOR.VALUE>.Publisher,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
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



