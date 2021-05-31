//
//  Publisher+Validator.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Sha. All rights reserved.
//

import Combine
import Foundation

/// These extensions include simple functions for
/// different validators
public extension Published.Publisher where Value == String {

    func passwordMatchValidator(
            form: FormValidation,
            firstPassword: @autoclosure @escaping StringProducerClosure,
            secondPassword: @autoclosure @escaping StringProducerClosure,
            secondPasswordPublisher: Published<String>.Publisher,
            errorMessage: @autoclosure @escaping StringProducerClosure = ""
    ) -> ValidationContainer {
        let message = errorMessage()

        let pub1 = self.map {
            ValidatedPassword(password: $0, type: 0)
        }
        let pub2 = secondPasswordPublisher.map {
            ValidatedPassword(password: $0, type: 1)
        }
        let merged = pub1.merge(with: pub2)
                .dropFirst()
                .eraseToAnyPublisher()
        return ValidationPublishers.create(
                form: form,
                validator: PasswordMatcherValidator(firstPassword: firstPassword(), secondPassword: secondPassword()),
                for: merged,
                errorMessage: !message.isEmpty ? message : form.messages.passwordsNotMatching)
    }

/*
 let other = otherPassword
            guard !value.isEmpty else {
                return false
            }
            guard !other.isEmpty else {
                return false
            }
 */
    func inlineValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            callback: @escaping ValidationCallback) -> ValidationContainer {
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: InlineValidator(condition: callback),
                for: self.eraseToAnyPublisher(),
                errorMessage: !message.isEmpty ? message : form.messages.required)
    }

    func nonEmptyValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = ""
    ) -> ValidationContainer {
        let validator = NonEmptyValidator()
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                errorMessage: !message.isEmpty ? message : form.messages.required)
    }

    func patternValidator(
            form: FormValidation,
            pattern: String,
            errorMessage: @autoclosure @escaping StringProducerClosure = ""
    ) -> ValidationContainer {
        let validator = PatternValidator(pattern: try! NSRegularExpression(pattern: pattern))
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                errorMessage: !message.isEmpty ? message : form.messages.invalidPattern)
    }

    func emailValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = ""
    ) -> ValidationContainer {
        let validator = EmailValidator()
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                errorMessage: !message.isEmpty ? message : form.messages.invalidEmailAddress)
    }

}

public extension Published.Publisher where Value == Date {
    func dateValidator(
            form: FormValidation,
            before: Date = .distantFuture,
            after: Date = .distantPast,
            errorMessage: @autoclosure @escaping StringProducerClosure = ""
    ) -> ValidationContainer {
        let validator = DateValidator(before: before, after: after)
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                errorMessage: !message.isEmpty ? message : form.messages.invalidDate)
    }
}
