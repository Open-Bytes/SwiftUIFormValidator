//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import UIKit
import FormValidator


class ExampleForm: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastNames: String = ""
    @Published var firstLine: String = ""
    @Published var address: String = ""
    @Published var street: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var birthday: Date = Date()

    @Published var validation = FormValidation(validationType: .immediate, messages: ValidationMessages())

    lazy var firstNameValidation: ValidationContainer = {
        $firstName.nonEmptyValidator(form: validation)
    }()

    lazy var lastNamesValidation: ValidationContainer = {
        $lastNames.inlineValidator(form: validation) { value in
            value.isEmpty ? "This field is required" : nil
        }
    }()

    lazy var firstLineValidation: ValidationContainer = {
        $firstLine.countValidator(
                form: validation,
                count: 6,
                type: .greaterThanOrEquals,
                onValidate: { validation in
                    switch validation {
                    case .success:
                        print("Success")
                    case .failure(let error):
                        print("Failure: \(error)")
                    }
                })
    }()

    lazy var addressValidation: ValidationContainer = {
        let validators: [StringValidator] = [
            PrefixValidator(prefix: "n", message: "Must start with (n)."),
            CountValidator(count: 6, type: .greaterThanOrEquals, message: "Must be at least 6 characters.")
        ]
        return $address.allValid(validators: validators, form: validation)
    }()

    lazy var streetValidation: ValidationContainer = {
        let validators: [StringValidator] = [
            PrefixValidator(prefix: "st.", message: "Must start with (st.)."),
            CountValidator(count: 6, type: .greaterThanOrEquals, message: "Must be at least 6 characters.")
        ]
        return $street.anyValid(validators: validators, form: validation)
    }()

    lazy var passwordValidation: ValidationContainer = {
        $password.passwordMatchValidator(
                form: validation,
                firstPassword: self.password,
                secondPassword: self.confirmPassword,
                secondPasswordPublisher: self.$confirmPassword)
    }()

    lazy var birthdayValidation: ValidationContainer = {
        $birthday.dateValidator(form: validation, before: Date(), message: "Date must be before today")
    }()

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
