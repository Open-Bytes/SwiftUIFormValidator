//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public typealias ValidationCallback = (String) -> Bool

/// This validator Validates if a condition is valid or not.
public class InlineValidator: FormValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var latestValidation: Validation = .failure(message: "")
    public var onChanged: ((Validation) -> Void)? = nil

    private let condition: ValidationCallback

    public init(condition: @escaping ValidationCallback) {
        self.condition = condition
    }

    public func validate(
            value: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> Validation {
        condition(value) ? .success : .failure(message: errorMessage())
    }

}
