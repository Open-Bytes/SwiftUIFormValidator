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

    func inlineValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "",
            callback: @escaping ValidationCallback) -> ValidationContainer {
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: InlineValidator(condition: callback),
                for: self,
                errorMessage: !message.isEmpty ? message : form.messages.required)
    }

    func nonEmptyValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = ""
    ) -> ValidationContainer {
        let validator = NonEmptyValidator()
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: !message.isEmpty ? message : form.messages.required)
    }

    func patternValidator(
            form: FormValidation,
            pattern: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = ""
    ) -> ValidationContainer {
        let validator = PatternValidator(pattern: try! NSRegularExpression(pattern: pattern))
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: !message.isEmpty ? message : form.messages.invalidPattern)
    }

    func emailValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = ""
    ) -> ValidationContainer {
        let validator = EmailValidator()
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: !message.isEmpty ? message : form.messages.invalidEmailAddress)
    }

}

public extension Published.Publisher where Value == Date {
    func dateValidator(
            form: FormValidation,
            before: Date = .distantFuture,
            after: Date = .distantPast,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = ""
    ) -> ValidationContainer {
        let validator = DateValidator(before: before, after: after)
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: !message.isEmpty ? message : form.messages.invalidDate)
    }
}
