//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator validates if a string is empty of blank.
public class NonEmptyValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    public init() {
    }

    public var errorMessage: StringProducerClosure = {
        ""
    }
    public var value: String = ""

    public func validate() -> Validation {
        if value.trimmingCharacters(in: .whitespaces).isEmpty {
            return .failure(message: errorMessage())
        }
        return .success
    }

    public var isEmpty: Bool {
        value.isEmpty
    }

}
