//
// Created by Shaban on 14/05/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import Combine

@propertyWrapper
public class FormField {
    @Published
    private var value: String
    private let validator: StringValidator

    public var projectedValue: AnyPublisher<String, Never> {
        $value.eraseToAnyPublisher()
    }

    public var wrappedValue: String {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public init(wrappedValue value: String, validator: () -> StringValidator) {
        self.value = value
        self.validator = validator()
    }

    public init(wrappedValue value: String, validator: StringValidator) {
        self.value = value
        self.validator = validator
    }

    public init(initialValue value: String, validator: () -> StringValidator) {
        self.value = value
        self.validator = validator()
    }

    public func validation(
            form: FormValidation,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil) -> ValidationContainer {
        let pub: AnyPublisher<String, Never> = $value.eraseToAnyPublisher()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: pub,
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}