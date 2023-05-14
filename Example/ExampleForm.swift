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

    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var lastName: String = ""

    @FormField(inlineValidator: { value in
        guard value > 0 else {
            return "Age can not be ≤ 0"
        }
        guard value <= 50 else {
            return "Age can not be > 50"
        }
        return nil
    })
    var age: Int = 0

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
                type: .any(messageTitle: "At least one of the following is required:"),
                strategy: .all)
    })
    var street: String = ""

    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var city: String = ""

    @PasswordFormField(message: "The passwords do not match.")
    var password: String = ""
    @PasswordFormField(message: "The passwords do not match.")
    var confirmPassword: String = ""

    @DateFormField(message: "Date can not be in the future!")
    var birthday: Date = Date()

    @Published
    var validation = FormValidation(validationType: .immediate)

    lazy var firstNameValidation = _firstName.validation(form: validation)

    lazy var cityValidation = _city.validation(form: validation)

    lazy var ageValidation = _age.validation(form: validation)

    lazy var lastNameValidation = _lastName.validation(form: validation)

    lazy var firstLineValidation = _firstLine.validation(form: validation)

    lazy var addressValidation = _address.validation(form: validation)

    lazy var streetValidation = _street.validation(form: validation)

    lazy var passwordValidation = _password.validation(form: validation, other: _confirmPassword)

    lazy var birthdayValidation = _birthday.validation(form: validation, before: Date())
}