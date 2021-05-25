//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine

public class DateValidator: FormValidator {
    public var latestValidation: Validation = .failure(message: "")
    public var onChanged: ((Validation) -> Void)? = nil

    private let before: Date
    private let after: Date

    public init(before: Date, after: Date) {
        self.before = before
        self.after = after
    }

    public func validate(
            value: Date,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> Validation {
        value > after && value < before ?
                Validation.success :
                Validation.failure(message: errorMessage())
    }
}
