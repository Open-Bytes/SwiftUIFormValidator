//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import Foundation

/// This validator validates if a patten is matched or not.
public class PatternValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    private let pattern: NSRegularExpression

    public init(pattern: NSRegularExpression, message: @autoclosure @escaping StringProducerClosure) {
        self.pattern = pattern
        self.message = message
    }

    public let message: StringProducerClosure

    public var value: String? = ""

    public func validate() -> Validation {
        guard let value else {
            return .success
        }
        let range = NSRange(location: 0, length: value.count)
        guard pattern.firstMatch(in: value, options: [], range: range) != nil else {
            return .failure(message: message())
        }
        return .success
    }

}
