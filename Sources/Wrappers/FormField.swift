//
// Created by Shaban on 14/05/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import Combine

@propertyWrapper
public class FormField<Value, Validator: Validatable> where Value == Validator.Value {
    @Published
    private var value: Value
    private let validator: Validator

    public var projectedValue: AnyPublisher<Value, Never> {
        $value.eraseToAnyPublisher()
    }

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public init(wrappedValue value: Value, validator: () -> Validator) {
        self.value = value
        self.validator = validator()
    }

    public init(wrappedValue value: Value, validator: Validator) {
        self.value = value
        self.validator = validator
    }

    public init(initialValue value: Value, validator: () -> Validator) {
        self.value = value
        self.validator = validator()
    }

    public func validation(
            form: FormValidation,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil) -> ValidationContainer {
        let pub: AnyPublisher<Value, Never> = $value.eraseToAnyPublisher()
        return ValidationFactory.create(
                form: form,
                validator: validator,
                for: pub,
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}

public extension FormField where Validator == InlineValidator<Value> {

    convenience init(wrappedValue value: Value, inlineValidator: @escaping (Value) -> String?) {
        self.init(wrappedValue: value, validator: InlineValidator(condition: inlineValidator))
    }

}