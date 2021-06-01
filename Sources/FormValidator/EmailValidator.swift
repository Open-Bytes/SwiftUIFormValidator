//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import Foundation

/// This validator validates if the email is valid or not.
public class EmailValidator: StringValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: ((Validation) -> Void)? = nil

    public init() {
    }

    public var errorMessage: StringProducerClosure = {
        ""
    }
    public var value: String = ""

    public func validate() -> Validation {
        guard !value.isEmpty else {
            return .failure(message: errorMessage())
        }

        let nsPattern = try! NSRegularExpression(
                pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$",
                options: .caseInsensitive)
        let match = nsPattern.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count))
        if match == nil {
            return .failure(message: errorMessage())
        }
        return .success
    }

}
