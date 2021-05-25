//
//  Publisher+Validator.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Sha. All rights reserved.
//

import Combine

public extension Published.Publisher where Value == String {

    func inlineValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "Required",
            callback: @escaping ValidationCallback) -> ValidationContainer {
        ValidationPublishers.create(
                form: form,
                validator: InlineValidator(condition: callback),
                for: self,
                errorMessage: errorMessage())
    }

    func nonEmptyValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "Required") -> ValidationContainer {
        let validator = NonEmptyValidator()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: errorMessage())
    }

    func patternValidator(
            form: FormValidation,
            pattern: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "Invalid pattern"
    ) -> ValidationContainer {
        let validator = MatcherValidator(pattern: try! NSRegularExpression(pattern: pattern))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: errorMessage())
    }

    func emailValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "Invalid email address"
    ) -> ValidationContainer {
        let validator = EmailValidator()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: errorMessage())
    }

}

public extension Published.Publisher where Value == Date {
    func dateValidator(
            form: FormValidation,
            before: Date = .distantFuture,
            after: Date = .distantPast,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "Invalid date"
    ) -> ValidationContainer {
        let validator = DateValidator(before: before, after: after)
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: errorMessage())
    }
}
