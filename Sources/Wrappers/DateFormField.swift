//
// Created by Shaban on 14/05/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import Combine

@propertyWrapper
public class DateFormField {
    @Published
    private var value: Date
    private let message: String

    public var projectedValue: AnyPublisher<Date, Never> {
        $value.eraseToAnyPublisher()
    }

    public var wrappedValue: Date {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public init(wrappedValue value: Date, message: String) {
        self.value = value
        self.message = message
    }

    public init(initialValue value: Date, message: String) {
        self.value = value
        self.message = message
    }

    public func validation(
            form: FormValidation,
            before: Date = .distantFuture,
            after: Date = .distantPast,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let validator = DateValidator(
                before: before,
                after: after,
                message: self.message)
        let pub: AnyPublisher<Date, Never> = $value.eraseToAnyPublisher()
        return ValidationFactory.create(
                form: form,
                validator: validator,
                for: pub,
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}