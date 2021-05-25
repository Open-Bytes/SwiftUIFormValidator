//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine
import UIKit
import FormValidator

class FormInfo: ObservableObject {
    @Published var firstName: String = ""
    @Published var middleNames: String = ""
    @Published var lastNames: String = ""
    @Published var birthday: Date = Date()
    @Published var addressHouseNumberOrName: String = ""
    @Published var addressFirstLine: String = ""
    @Published var addressSecondLine: String = ""
    @Published var addressCountry: String = ""

    let form = FormValidation()

    lazy var firstNameValidation: ValidationPublisher = {
        $firstName.nonEmptyValidator(form: form)
    }()

    lazy var lastNamesValidation: ValidationPublisher = {
        $lastNames.nonEmptyValidator(form: form)
    }()

    lazy var birthdayValidation: ValidationPublisher = {
        $birthday.dateValidator(form: form, before: Date(), errorMessage: "Date must be before today")
    }()

    lazy var addressHouseNumberOrNameValidation: ValidationPublisher = {
        $addressHouseNumberOrName.nonEmptyValidator(form: form)
    }()

    lazy var addressFirstLineValidation: ValidationPublisher = {
        $addressFirstLine.nonEmptyValidator(form: form)
    }()


}
