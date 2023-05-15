//
// Created by Shaban on 14/05/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import Combine
import Foundation

@propertyWrapper
public class PasswordFormField {
    @Published
    private var value: String
    private let message: PasswordMatchingMessage

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

    public init(wrappedValue value: String,
                message: @escaping @autoclosure PasswordMatchingMessage) {
        self.value = value
        self.message = message
    }

    public init(initialValue value: String,
                message: @escaping @autoclosure PasswordMatchingMessage) {
        self.value = value
        self.message = message
    }

    public func validation(
            manager: FormManager,
            other: PasswordFormField,
            pattern: NSRegularExpression? = nil,
            disableValidation: @escaping DisableValidationClosure = {
                false
            },
            onValidate: OnValidate? = nil
    ) -> ValidationContainer {
        let pub = $value.eraseToAnyPublisher()
                .map {
                    ValidatedPassword(password: $0, type: 0)
                }
        let pub2 = other.projectedValue.map {
            ValidatedPassword(password: $0, type: 1)
        }
        let merged = pub.merge(with: pub2)
                .dropFirst()
                .eraseToAnyPublisher()

        let validator = PasswordMatchValidator(
                firstPassword: self.value,
                secondPassword: other.value,
                pattern: pattern,
                message: self.message())
        return ValidationFactory.create(
                manager: manager,
                validator: validator,
                for: merged,
                disableValidation: disableValidation,
                onValidate: onValidate)
    }
}