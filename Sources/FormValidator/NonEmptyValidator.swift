//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator Validates if a string is empty of blank.
public class NonEmptyValidator: FormValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var latestValidation: Validation = .failure(message: "")
    public var onChanged: ((Validation) -> Void)? = nil

    public init() {
    }

    public func validate(
            value: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> Validation {
        if value.trimmingCharacters(in: .whitespaces).isEmpty {
            return .failure(message: errorMessage())
        }
        return .success
    }

}
