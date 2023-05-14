//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import UIKit
import FormValidator

class ExampleForm: ObservableObject {

    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var firstName: String = ""

    @FormField(validator: {
        InlineValidator { value in
            value.isEmpty ? "This field is required" : nil
        }
    })
    var lastNames: String = ""

    @FormField(validator: {
        CountValidator(
                count: 6,
                type: .greaterThanOrEquals,
                message: "This fields's length must be ≥ 6")
    })
    var firstLine: String = ""

    @FormField(validator: {
        let validators: [any StringValidator] = [
            PrefixValidator(prefix: "n", message: "Must start with (n)."),
            CountValidator(count: 6, type: .greaterThanOrEquals, message: "Must be at least 6 characters.")
        ]
        return CompositeValidator(
                validators: validators,
                type: .all,
                strategy: .all)
    })
    var address: String = ""

    @FormField(validator: {
         CompositeValidator(
                validators: [
                    PrefixValidator(prefix: "n", message: "Must start with (n)."),
                    CountValidator(count: 6, type: .greaterThanOrEquals, message: "Must be at least 6 characters.")
                ],
                type: .any,
                strategy: .all)
    })
    var street: String = ""


    @PasswordFormField(message: "The passwords do not match.")
    var password: String = ""
    @PasswordFormField(message: "The passwords do not match.")
    var confirmPassword: String = ""

    @DateFormField(message: "Date can not be in the future!")
    var birthday: Date = Date()

    @Published
    var validation = FormValidation(validationType: .immediate, messages: ValidationMessages())

    lazy var firstNameValidation = _firstName.validation(form: validation)

    lazy var lastNamesValidation = _lastNames.validation(form: validation)

    lazy var firstLineValidation = _firstLine.validation(form: validation)

    lazy var addressValidation = _address.validation(form: validation)

    lazy var streetValidation = _street.validation(form: validation)

    lazy var passwordValidation = _password.validation(form: validation, other: _confirmPassword)

    lazy var birthdayValidation = _birthday.validation(form: validation, before: Date())
}

/// All validation messages are included in DefaultValidationMessages, which allows you to easily access
/// and customize any message as needed. By overriding a specific message, you can provide your own
/// custom message for that validation rule, giving you greater control and flexibility
/// over the validation process.
class ValidationMessages: DefaultValidationMessages {
    public override var required: String {
        "This field is required."
    }
}
