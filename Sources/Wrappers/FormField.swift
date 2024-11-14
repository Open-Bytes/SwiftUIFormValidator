//
// Created by Shaban on 14/05/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import Combine


@propertyWrapper
public class FormField<Value: Equatable, Validator: Validatable> where Value == Validator.Value {
    
    private var subject: CurrentValueSubject<Value, Never>
    private let validator: Validator

    public var wrappedValue: Value {
        get {
            subject.value
        }
        set {
            subject.send(newValue)
        }
    }

    public init(wrappedValue value: Value, validator: () -> Validator) {
        self.subject = CurrentValueSubject(value)
        self.validator = validator()
    }

    public init(wrappedValue value: Value, validator: Validator) {
        self.subject = CurrentValueSubject(value)
        self.validator = validator
    }

    public init(initialValue value: Value, validator: () -> Validator) {
        self.subject = CurrentValueSubject(value)
        self.validator = validator()
    }
    
    public static subscript<EnclosingSelf>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, FormField>
    ) -> Value {
        get { object[keyPath: storageKeyPath].wrappedValue }
        set {
            if let observableObject = object as? (any ObservableObject),
               let objectWillChange = (observableObject.objectWillChange as any Publisher) as? ObservableObjectPublisher {
                objectWillChange.send()
            }
            object[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }

    public func validation(
            manager: FormManager,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let pub: AnyPublisher<Value, Never> = subject.eraseToAnyPublisher()
        return ValidationFactory.create(
                manager: manager,
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
