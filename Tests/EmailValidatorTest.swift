//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class EmailValidatorTest: XCTestCase {
    private var validator: EmailValidator!

    override func setUp() {
        validator = EmailValidator()
    }

    func testValidator_shouldBeValid() {
        validator.value = "sh3ban.kamel@gmail.com"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        validator.value = "sh3ban.kamel"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}