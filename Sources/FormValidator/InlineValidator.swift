//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public typealias ValidationCallback = (String) -> String?

/// This validator validates if a condition is valid or not.
public class InlineValidator<Value>: Validatable {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    private let condition: (Value) -> String?

    public init(condition: @escaping (Value) -> String?) {
        self.condition = condition
    }

    public let message: StringProducerClosure = {
        ""
    }

    public var value: Value? = nil

    public func validate() -> Validation {
        guard let value else {
            return .success
        }
        guard let error = condition(value) else {
            return .success
        }
        return .failure(message: error)
    }

}
