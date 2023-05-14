//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator checks whether a password meets the required criteria or not.
public class PasswordValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []
    let pattern: NSRegularExpression

    public init(
            pattern: NSRegularExpression? = nil,
            message: @autoclosure @escaping StringProducerClosure) {
        if let pattern {
            self.pattern = pattern
        } else {
            self.pattern = try! NSRegularExpression(
                    pattern: Regex.password.rawValue,
                    options: .caseInsensitive)
        }
        self.message = message
    }

    public let message: StringProducerClosure

    public var value: String? = ""

    public func validate() -> Validation {
        let patternValidator = PatternValidator(pattern: pattern, message: self.message())
        patternValidator.value = value
        return patternValidator.validate()
    }

}
