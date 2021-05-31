//
// Created by Shaban on 31/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public class CompositeValidator {

    public func validate(
            value: String,
            validators: [StringValidator],
            type: ValidationType,
            errorMessage: @autoclosure @escaping StringProducerClosure
    ) -> Validation {
        for item in validators {
            var val = item
            val.errorMessage = errorMessage
            val.value = value
        }

        switch type {
        case .all:
            let anyFails = validators.first {
                let validation = $0.validate()
                $0.onChanged?(validation)
                return validation.isFailure
            }
            return anyFails == nil ? .success : .failure(message: errorMessage())
        case .any:
            for validator in validators {
                let validation = validator.validate()
                validator.onChanged?(validation)
                if validation.isSuccess {
                    return .success
                }
            }
            return .failure(message: errorMessage())
        }

    }
}

extension CompositeValidator {

    public enum ValidationType {
        case all
        case any
    }

}