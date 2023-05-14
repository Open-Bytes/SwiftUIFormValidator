//
// Created by Shaban on 27/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator validates if a count is correct according to the type provided.
public class CountValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    public let message: StringProducerClosure

    public var value: String? = ""
    public var count: Int
    public let type: ValidationType

    public init(count: Int,
                type: ValidationType,
                message: @autoclosure @escaping StringProducerClosure) {
        self.count = count
        self.type = type
        self.message = message
    }

    public func validate() -> Validation {
        guard let value else {
            return .success
        }
        let val = value.trimmingCharacters(in: .whitespaces)
        var isValid: Bool
        switch type {
        case .equals:
            isValid = val.count == count
        case .lessThan:
            isValid = val.count < count
        case .lessThanOrEquals:
            isValid = val.count <= count
        case .greaterThan:
            isValid = val.count > count
        case .greaterThanOrEquals:
            isValid = val.count >= count
        }

        guard isValid else {
            return .failure(message: message())
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