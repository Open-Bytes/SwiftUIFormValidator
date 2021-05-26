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
        let valid = validator.validate(value: "sh3ban.kamel@gmail.com", errorMessage: "invalid")
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        validator = InlineValidator { value in
            value == "x"
        }
        let valid = validator.validate(value: "sh3ban.kamel", errorMessage: "invalid")
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}