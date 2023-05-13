//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import UIKit
import FormValidator

// 1

class ExampleForm: ObservableObject {
    @Published var firstName: String = ""
    @Published var middleNames: String = ""
    @Published var lastNames: String = ""
    @Published var birthday: Date = Date()
    @Published var street: String = ""
    @Published var firstLine: String = ""
    @Published var secondLine: String = ""
    @Published var country: String = ""

    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // 2
    @Published var validation = FormValidation(validationType: .immediate, messages: ValidationMessages())

    // 3
    lazy var firstNameValidation: ValidationContainer = {
        let validators: [StringValidator] = [
            CountValidator(count: 6, type: .greaterThanOrEquals, message: "Should be at leas 6 characters."),
            PrefixValidator(prefix: "n", message: "Should start with n")
        ]
        return $firstName.allValid(validators: validators, form: validation)
    }()

    lazy var lastNamesValidation: ValidationContainer = {
        $lastNames.inlineValidator(form: validation) { value in
            value.isEmpty ? "This field is required" : nil
        }
    }()

    lazy var birthdayValidation: ValidationContainer = {
        $birthday.dateValidator(form: validation, before: Date(), message: "Date must be before today")
    }()

    lazy var streetValidation: ValidationContainer = {
        let validators: [StringValidator] = [
            CountValidator(count: 6, type: .greaterThanOrEquals, message: "Should be at leas 6 characters."),
            PrefixValidator(prefix: "st.", message: "Should start with st.")
        ]
        return $street.anyValid(validators: validators, form: validation)
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

    lazy var passwordValidation: ValidationContainer = {
        $password.passwordMatchValidator(
                form: validation,
                firstPassword: self.password,
                secondPassword: self.confirmPassword,
                secondPasswordPublisher: self.$confirmPassword)
    }()

}

/// All validation messages are included in DefaultValidationMessages, which allows you to easily access
/// and customize any message as needed. By overriding a specific message, you can provide your own
/// custom message for that validation rule, giving you greater control and flexibility
/// over the validation process.
class ValidationMessages: DefaultValidationMessages {
    public override var required: String {
        "Required field"
    }
}
