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
/// different validators creation
public extension Published.Publisher where Value == String {
    func anyValid(
            validators: [StringValidator],
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        ValidationPublishers.create(
                form: form,
                validators: validators,
                type: .any,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                errorMessage: errorMessage().orIfEmpty(form.messages.required))
    }
}

public extension Published.Publisher where Value == String {
    func allValid(
            validators: [StringValidator],
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        ValidationPublishers.create(
                form: form,
                validators: validators,
                type: .all,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                errorMessage: errorMessage().orIfEmpty(form.messages.required))
    }
}

public extension Published.Publisher where Value == String {
    func passwordValidator(
            form: FormValidation,
            pattern: String = Regex.password.rawValue,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        patternValidator(
                form: form,
                pattern: pattern,
                errorMessage: errorMessage().orIfEmpty(form.messages.passwordRegexDescription))
    }
}

public struct Password {
    public static let pattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
}

public extension Published.Publisher where Value == String {
    func passwordMatchValidator(
            form: FormValidation,
            firstPassword: @autoclosure @escaping StringProducerClosure,
            secondPassword: @autoclosure @escaping StringProducerClosure,
            secondPasswordPublisher: Published<String>.Publisher,
            pattern: NSRegularExpression? = nil,
            errorMessage: @autoclosure @escaping StringProducerClosure = ""
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
                pattern: pattern
        )
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: merged,
                errorMessage: errorMessage().orIfEmpty(form.messages.passwordsNotMatching))
    }
}

public extension Published.Publisher where Value == String {
    func inlineValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            callback: @escaping ValidationCallback) -> ValidationContainer {
        ValidationPublishers.create(
                form: form,
                validator: InlineValidator(condition: callback),
                for: self.eraseToAnyPublisher(),
                errorMessage: errorMessage().orIfEmpty(form.messages.required))
    }
}

public extension Published.Publisher where Value == String {
    func nonEmptyValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        let validator = NonEmptyValidator()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                errorMessage: errorMessage().orIfEmpty(form.messages.required))
    }
}

public extension Published.Publisher where Value == String {
    func patternValidator(
            form: FormValidation,
            pattern: String,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        let validator = PatternValidator(pattern: try! NSRegularExpression(pattern: pattern))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                errorMessage: errorMessage().orIfEmpty(form.messages.invalidPattern))
    }
}

public extension Published.Publisher where Value == String {
    func emailValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        let validator = EmailValidator()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                errorMessage: errorMessage().orIfEmpty(form.messages.invalidEmailAddress))
    }
}

public extension Published.Publisher where Value == String {
    func countValidator(
            form: FormValidation,
            count: Int,
            type: CountValidator.ValidationType,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        let validator = CountValidator(count: count, type: type)
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                errorMessage: errorMessage().orIfEmpty(form.messages.invalidCount(count, type: type)))
    }
}

public extension Published.Publisher where Value == Date {
    func dateValidator(
            form: FormValidation,
            before: Date = .distantFuture,
            after: Date = .distantPast,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            }
    ) -> ValidationContainer {
        let validator = DateValidator(before: before, after: after)
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                errorMessage: errorMessage().orIfEmpty(form.messages.invalidDate))
    }
}
