//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator Validates if a string is empty of blank.
public class PrefixValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: ((Validation) -> Void)? = nil

    public var errorMessage: StringProducerClosure = {
        ""
    }
    public var value: String = ""
    public var prefix: String = ""
    public var ignoreCase: Bool = true

    public init(prefix: String, ignoreCase: Bool = true) {
        self.prefix = ignoreCase ? prefix.lowercased() : prefix
    }

    public func validate() -> Validation {
        let text = ignoreCase ? value.lowercased() : value
        guard text.hasPrefix(prefix) else {
            return .failure(message: errorMessage())
        }
        return .success
    }

}
