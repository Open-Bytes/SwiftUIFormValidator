//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine

public class MatcherValidator: FormValidator {
    public var latestValidation: Validation = .failure(message: "")
    public var onChanged: ((Validation) -> Void)? = nil

    private let pattern: NSRegularExpression

    public init(pattern: NSRegularExpression) {
        self.pattern = pattern
    }

    public func validate(
            value: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> Validation {
        let range = NSRange(location: 0, length: value.count)
        guard pattern.firstMatch(in: value, options: [], range: range) != nil else {
            return .failure(message: errorMessage())
        }
        return .success
    }

}
