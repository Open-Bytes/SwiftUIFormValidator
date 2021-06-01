//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class InlineValidatorTest: XCTestCase {
    private var validator: InlineValidator!

    override func setUp() {

    }

    func testValidator_shouldBeValid() {
        validator = InlineValidator { value in
            value == "sh3ban.kamel@gmail.com"
        }
        validator.value = "sh3ban.kamel@gmail.com"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        validator = InlineValidator { value in
            value == "x"
        }
        validator.value = "sh3ban.kamel"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}