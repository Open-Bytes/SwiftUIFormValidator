//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import UIKit
import FormValidator

class ExampleForm: ObservableObject {
    @Published
    var manager = FormManager(validationType: .immediate)

    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var firstName: String = ""
    lazy var firstNameValidation = _firstName.validation(manager: manager)

    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var lastName: String = ""
    lazy var lastNameValidation = _lastName.validation(manager: manager)

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
    lazy var ageValidation = _age.validation(manager: manager)

    @FormField(validator: {
        CountValidator(
                count: 6,
                type: .greaterThanOrEquals,
                message: "This fields's length must be ≥ 6")
    })
    var firstLine: String = ""
    lazy var firstLineValidation = _firstLine.validation(manager: manager)

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
    lazy var addressValidation = _address.validation(manager: manager)

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
    lazy var streetValidation = _street.validation(manager: manager)

    @FormField(validator: NonEmptyValidator(message: "This field is required!"))
    var city: String = ""
    lazy var cityValidation = _city.validation(manager: manager)

    @PasswordFormField(message: (
            empty: "This field is required!",
            notMatching: "The passwords do not match!",
            invalidPattern: "Your password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."))
    var password: String = ""
    @PasswordFormField(message: (
            empty: "This field is required!",
            notMatching: "The passwords do not match!",
            invalidPattern: "Your password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one number, and one special character."))
    var confirmPassword: String = ""
    lazy var passwordValidation = _password.validation(
            manager: manager,
            other: _confirmPassword,
            pattern: try! NSRegularExpression(
                    pattern: Regex.password.rawValue,
                    options: .caseInsensitive)
    )

    @DateFormField(message: "Date can not be in the future!")
    var birthday: Date = Date()
    lazy var birthdayValidation = _birthday.validation(manager: manager, before: Date())
}