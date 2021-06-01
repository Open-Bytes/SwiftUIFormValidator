//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

/// This validator validates if a string is empty of blank.
public class SuffixValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: ((Validation) -> Void)? = nil

    public var errorMessage: StringProducerClosure = {
        ""
    }
    public var value: String = ""
    public var suffix: String = ""
    public var ignoreCase: Bool = true

    public init(suffix: String, ignoreCase: Bool = true) {
        self.suffix = ignoreCase ? suffix.lowercased() : suffix
    }

    public func validate() -> Validation {
        let text = ignoreCase ? value.lowercased() : value
        guard text.hasSuffix(suffix) else {
            return .failure(message: errorMessage())
        }
        return .success
    }
}
