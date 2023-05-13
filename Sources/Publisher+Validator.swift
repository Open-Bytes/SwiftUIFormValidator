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
    func passwordValidator(
            form: FormValidation,
            pattern: String = Regex.password.rawValue,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        patternValidator(
                form: form,
                pattern: pattern,
                errorMessage: errorMessage().orIfEmpty(FormValidation.messages.passwordRegexDescription),
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {
    func passwordMatchValidator(
            form: FormValidation,
            firstPassword: @autoclosure @escaping StringProducerClosure,
            secondPassword: @autoclosure @escaping StringProducerClosure,
            secondPasswordPublisher: Published<String>.Publisher,
            pattern: NSRegularExpression? = nil,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
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
                errorMessage: errorMessage().orIfEmpty(FormValidation.messages.passwordsNotMatching)
        )
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: merged,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {
    func inlineValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
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
    func nonEmptyValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = NonEmptyValidator(errorMessage: errorMessage().orIfEmpty(FormValidation.messages.required))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {
    func patternValidator(
            form: FormValidation,
            pattern: String,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = PatternValidator(
                pattern: try! NSRegularExpression(pattern: pattern),
                errorMessage: errorMessage().orIfEmpty(FormValidation.messages.invalidPattern))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension Published.Publisher where Value == String {
    func emailValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping StringProducerClosure = "",
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = EmailValidator(errorMessage: errorMessage().orIfEmpty(FormValidation.messages.invalidEmailAddress))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
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
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = CountValidator(
                count: count,
                type: type,
                errorMessage: errorMessage().orIfEmpty(FormValidation.messages.invalidCount(count, type: type)))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
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
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = DateValidator(
                before: before,
                after: after,
                errorMessage: errorMessage().orIfEmpty(FormValidation.messages.invalidDate))
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self.eraseToAnyPublisher(),
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}
