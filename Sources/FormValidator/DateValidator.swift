//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import Foundation

/// This validator Validates if a date falls within `after` & `before`.
public class DateValidator: FormValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
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
            errorMessage: @autoclosure @escaping StringProducerClosure
    ) -> Validation {
        value < before && value > after ?
                Validation.success :
                Validation.failure(message: errorMessage())
    }
}
