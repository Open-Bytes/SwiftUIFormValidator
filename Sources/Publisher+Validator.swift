//
//  Publisher+Validator.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import Combine

public extension Published.Publisher where Value == String {

    func nonEmptyValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "Required") -> ValidationPublisher {
        let validator = NonEmptyValidator()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: errorMessage())
    }

    func matcherValidator(
            form: FormValidation,
            pattern: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = "Invalid pattern"
    ) -> ValidationPublisher {
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
    ) -> ValidationPublisher {
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
    ) -> ValidationPublisher {
        let validator = DateValidator(before: before, after: after)
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: errorMessage())
    }
}
