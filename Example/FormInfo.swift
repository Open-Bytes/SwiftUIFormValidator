//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import UIKit
import FormValidator

// 1
class FormInfo: ObservableObject {
    @Published var firstName: String = ""
    @Published var middleNames: String = ""
    @Published var lastNames: String = ""
    @Published var birthday: Date = Date()
    @Published var house: String = ""
    @Published var firstLine: String = ""
    @Published var secondLine: String = ""
    @Published var country: String = ""


    // 2
    lazy var form = {
        FormValidation(validationType: .deferred, messages: ValidationMessages())
    }()

    // 3
    lazy var firstNameValidation: ValidationContainer = {
        $firstName.nonEmptyValidator(form: form)
    }()

    lazy var lastNamesValidation: ValidationContainer = {
        $lastNames.inlineValidator(form: form) { value in
            if value.isEmpty { return false }
            return true
        }
    }()

    lazy var birthdayValidation: ValidationContainer = {
        $birthday.dateValidator(form: form, before: Date(), errorMessage: "Date must be before today")
    }()

    lazy var street: ValidationContainer = {
        $house.nonEmptyValidator(form: form)
    }()

    lazy var streetValidation: ValidationContainer = {
        $firstLine.nonEmptyValidator(form: form)
    }()

}

class ValidationMessages: DefaultValidationMessages {
    public override var required: String {
        "Required field"
    }
}
