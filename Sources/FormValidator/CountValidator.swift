//
// Created by Shaban on 27/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator validates if a count is correct according to the type provided.
public class CountValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: ((Validation) -> Void)? = nil

    public var errorMessage: StringProducerClosure = {
        ""
    }
    public var value: String = ""
    public var count: Int
    public let type: ValidationType

    public init(count: Int, type: ValidationType) {
        self.count = count
        self.type = type
    }

    public func validate() -> Validation {
        let value = value.trimmingCharacters(in: .whitespaces)
        var isValid: Bool
        switch type {
        case .equals:
            isValid = value.count == count
        case .lessThan:
            isValid = value.count < count
        case .lessThanOrEquals:
            isValid = value.count <= count
        case .greaterThan:
            isValid = value.count > count
        case .greaterThanOrEquals:
            isValid = value.count >= count
        }

        guard isValid else {
            return .failure(message: errorMessage())
        }

        return .success
    }

    public enum ValidationType {
        case equals
        case lessThan
        case lessThanOrEquals
        case greaterThan
        case greaterThanOrEquals
    }
}