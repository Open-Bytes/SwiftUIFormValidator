//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator validates if a string is empty of blank.
public class SuffixValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    public let message: StringProducerClosure

    public var value: String? = ""
    public var suffix: String = ""
    public var ignoreCase: Bool

    public init(suffix: String,
                ignoreCase: Bool = true,
                message: @autoclosure @escaping StringProducerClosure) {
        self.ignoreCase = ignoreCase
        self.suffix = ignoreCase ? suffix.lowercased() : suffix
        self.message = message
    }

    public func validate() -> Validation {
        guard let value else {
            return .success
        }
        let text = ignoreCase ? value.lowercased() : value
        guard text.hasSuffix(suffix) else {
            return .failure(message: message())
        }
        return .success
    }

}
