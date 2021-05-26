//
// Created by Shaban on 27/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import FormValidator
import Foundation

// 1
class CountValidator: FormValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var latestValidation: Validation = .failure(message: "")
    public var onChanged: ((Validation) -> Void)? = nil

    func validate(
            value: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> Validation {
        guard value.count == 2 else {
            return .failure(message: errorMessage())
        }
        return .success
    }
}

// 2
public extension Published.Publisher where Value == String {
    func countValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = ""
    ) -> ValidationContainer {
        let validator = CountValidator()
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: !message.isEmpty ? message : "Count must be 2")
    }
}
