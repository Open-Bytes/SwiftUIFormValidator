//
//  Publisher+Validator.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Sha. All rights reserved.
//

import Combine
import Foundation

/// These extensions provide convenient functions for
/// creating various types of validators.
public extension Published.Publisher where Value == String {

    /// A composite validator that validates an input only if any of
    /// the individual validators provided as input is valid.
    ///
    /// - Parameters:
    ///   - validators: the individual validators
    ///   - form: the FormValidation instance
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    func anyValid(
            validators: [StringValidator],
            form: FormValidation,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        ValidationPublishers.create(
                form: form,
                validators: validators,
                type: .any,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {

    /// A composite validator that validates an input only if all of
    /// the individual validators provided as input are valid.
    ///
    /// - Parameters:
    ///   - validators: the individual validators
    ///   - form: the FormValidation instance
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    func allValid(
            validators: [StringValidator],
            form: FormValidation,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        ValidationPublishers.create(
                form: form,
                validators: validators,
                type: .all,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {

    /// This validator checks whether the input string matches the specified pattern.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance
    ///   - pattern: the patterns, default: Regex.password
    ///   - message: the error message
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    func passwordValidator(
            form: FormValidation,
            pattern: String = Regex.password.rawValue,
            message: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        patternValidator(
                form: form,
                pattern: pattern,
                message: message().orIfEmpty(FormValidation.messages.passwordRegexDescription),
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {

    /// This validator checks whether the two password fields are matching
    /// with the possibility to match the specified pattern.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance.
    ///   - firstPassword: the first field.
    ///   - secondPassword: the second field.
    ///   - secondPasswordPublisher: the second field publisher.
    ///   - pattern: the patterns, default: nil.
    ///   - message: the error message
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    func passwordMatchValidator(
            form: FormValidation,
            firstPassword: @autoclosure @escaping StringProducerClosure,
            secondPassword: @autoclosure @escaping StringProducerClosure,
            secondPasswordPublisher: Published<String>.Publisher,
            pattern: NSRegularExpression? = nil,
            message: @autoclosure @escaping StringProducerClosure = "",
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let pub1 = self.map {
            ValidatedPassword(password: $0, type: 0)
        }
        let pub2 = secondPasswordPublisher.map {
            ValidatedPassword(password: $0, type: 1)
        }
        let merged = pub1.merge(with: pub2)
                .dropFirst()
                .eraseToAnyPublisher()

        let validator = PasswordMatchValidator(
                firstPassword: firstPassword(),
                secondPassword: secondPassword(),
                pattern: pattern,
                message: message().orIfEmpty(FormValidation.messages.passwordsNotMatching)
        )
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: merged,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {

    /// This validator enables you to apply customized validation conditions using the provided closure.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance.
    ///   - message: the error message
    ///   - onValidate: a closure invoked when validation changes
    ///   - callback: the closure that provides the customized condition
    /// - Returns: ValidationContainer
    func inlineValidator(
            form: FormValidation,
            message: @autoclosure @escaping StringProducerClosure = "",
            onValidate: OnValidate? = nil,
            callback: @escaping ValidationCallback) -> ValidationContainer {
        let validator = InlineValidator(condition: callback)
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {

    /// This validator checks whether the field is empty or not.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance.
    ///   - message: the error message
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    func nonEmptyValidator(
            form: FormValidation,
            message: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = NonEmptyValidator(message: message().orIfEmpty(FormValidation.messages.required))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {

    /// This validator checks whether the input string matches the specified pattern.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance.
    ///   - pattern: the pattern to validate.
    ///   - message: the error message
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns: ValidationContainer
    func patternValidator(
            form: FormValidation,
            pattern: String,
            message: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = PatternValidator(
                pattern: try! NSRegularExpression(pattern: pattern),
                message: message().orIfEmpty(FormValidation.messages.invalidPattern))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {

    /// This validator checks whether the input string matches the email pattern.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance.
    ///   - message: the error message.
    ///   - disableValidation: disable validation conditionally
    ///   - onValidate: a closure invoked when validation changes
    /// - Returns:
    func emailValidator(
            form: FormValidation,
            message: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = EmailValidator(message: message().orIfEmpty(FormValidation.messages.invalidEmailAddress))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}


public extension Published.Publisher where Value == String {

    /// This validator checks whether the input string matches the specified count.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance.
    ///   - count: the count.
    ///   - type: CountValidator.ValidationType
    ///   - message: the error message.
    ///   - disableValidation: disable validation conditionally.
    ///   - onValidate: a closure invoked when validation changes.
    /// - Returns:
    func countValidator(
            form: FormValidation,
            count: Int,
            type: CountValidator.ValidationType,
            message: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = CountValidator(
                count: count,
                type: type,
                message: message().orIfEmpty(FormValidation.messages.invalidCount(count, type: type)))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == Date {

    /// This validator verifies whether the input date falls within a specified date range.
    ///
    /// - Parameters:
    ///   - form: the FormValidation instance.
    ///   - before: the first date before the input.
    ///   - after: the second date after the input.
    ///   - message: the error message.
    ///   - disableValidation: disable validation conditionally.
    ///   - onValidate: a closure invoked when validation changes.
    /// - Returns:
    func dateValidator(
            form: FormValidation,
            before: Date = .distantFuture,
            after: Date = .distantPast,
            message: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = DateValidator(
                before: before,
                after: after,
                message: message().orIfEmpty(FormValidation.messages.invalidDate))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}
