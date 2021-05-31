//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public struct ValidatedPassword {
    let password: String
    let type: Int
}

public struct PasswordInfo {
    let pass1: String
    let pass2: String
}

/// This validator Validates if a condition is valid or not.
public class PasswordMatcherValidator: FormValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var latestValidation: Validation = .failure(message: "")
    public var onChanged: ((Validation) -> Void)? = nil

    private let firstPassword: StringProducerClosure
    private let secondPassword: StringProducerClosure

    public init(firstPassword: @autoclosure @escaping StringProducerClosure,
                secondPassword: @autoclosure @escaping StringProducerClosure) {
        self.firstPassword = firstPassword
        self.secondPassword = secondPassword
    }

    public func validate(
            value: ValidatedPassword,
            errorMessage: @autoclosure @escaping StringProducerClosure
    ) -> Validation {
        let p1 = value.type == 0 ? value.password : firstPassword()
        let p2 = value.type == 1 ? value.password : secondPassword()
        guard !p1.isEmpty else {
            return .failure(message: errorMessage())
        }
        guard !p2.isEmpty else {
            return .failure(message: errorMessage())
        }
        return p1 == p2 ? .success : .failure(message: errorMessage())
    }

}
