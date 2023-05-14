//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public struct ValidatedPassword {
    let password: String
    let type: Int

    public init(password: String, type: Int) {
        self.password = password
        self.type = type
    }
}

public struct PasswordInfo {
    let pass1: String
    let pass2: String
}

/// This validator validates if a condition is valid or not.
public class PasswordMatchValidator: Validatable {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    private let firstPassword: StringProducerClosure
    private let secondPassword: StringProducerClosure
    private let pattern: NSRegularExpression?

    public init(firstPassword: @autoclosure @escaping StringProducerClosure,
                secondPassword: @autoclosure @escaping StringProducerClosure,
                pattern: NSRegularExpression? = nil,
                message: @autoclosure @escaping StringProducerClosure) {
        self.firstPassword = firstPassword
        self.secondPassword = secondPassword
        self.pattern = pattern
        self.message = message
    }

    public let message: StringProducerClosure

    public var value: ValidatedPassword = ValidatedPassword(password: "", type: 0)

    public func validate() -> Validation {
        let isMatching = validateMatching()
        let isPatternValid = validatePattern()

        let isValid = isMatching && isPatternValid
        return isValid ? .success : .failure(message: message())
    }

    private func validateMatching() -> Bool {
        let p1 = value.type == 0 ? value.password : firstPassword()
        let p2 = value.type == 1 ? value.password : secondPassword()
        guard !p1.isEmpty else {
            return false
        }
        guard !p2.isEmpty else {
            return false
        }
        return p1 == p2
    }

    private func validatePattern() -> Bool {
        guard let pattern = pattern else {
            return true
        }
        let patternValidator = PatternValidator(pattern: pattern, message: self.message())
        patternValidator.value = value.password
        return patternValidator.validate().isSuccess
    }

    public var isEmpty: Bool {
        let p1 = value.type == 0 ? value.password : firstPassword()
        let p2 = value.type == 1 ? value.password : secondPassword()
        return !p1.isEmpty && !p2.isEmpty
    }
}
