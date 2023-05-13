//
// Created by Shaban on 31/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public class CompositeValidator: StringValidator {
    private let validators: [StringValidator]
    private let type: ValidationType

    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var onChanged: [OnValidationChange] = []

    public init(validators: [StringValidator], type: ValidationType) {
        self.validators = validators
        self.type = type
    }

    public let message: StringProducerClosure = {
        ""
    }
    public var value: String = ""

    public func validate() -> Validation {
        for item in validators {
            var val = item
            val.value = value
        }

        var errors = validators.compactMap {
            let validation = $0.validate()
            $0.valueChanged(validation)
            return validation.error
        }
        switch type {
        case .all:
            return errors.isEmpty ? .success : .failure(message: ErrorFormatter.format(errors: errors))
        case .any:
            for validator in validators {
                let validation = validator.validate()
                validator.valueChanged(validation)
                if validation.isSuccess {
                    return .success
                }
            }
            if let title = FormValidation.messages.anyValidTitle {
                errors = [title] + errors
            }
        }

        return errors.isEmpty ? .success : .failure(message: ErrorFormatter.format(errors: errors))
    }

    public var isEmpty: Bool {
        value.isEmpty
    }

}

extension CompositeValidator {

    public enum ValidationType {
        case all
        case any
    }

}