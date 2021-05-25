//
//  ValidationPublishers.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import Foundation
import Combine

public typealias ValidationPublisher = AnyPublisher<Validation, Never>

public class ValidationPublishers {

    public static func create<VALIDATOR: FormValidator>(
            form: FormValidation,
            validator: VALIDATOR,
            for publisher: Published<VALIDATOR.VALUE>.Publisher,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> ValidationPublisher {
        form.append(validator)
        return publisher.map { value in
                    let validation = validator.validate(value: value, errorMessage: errorMessage())
                    var val = validator
                    val.latestValidation = validation
                    val.onChanged?(val.latestValidation)
                    return validation
                }.dropFirst()
                .eraseToAnyPublisher()
    }
}



