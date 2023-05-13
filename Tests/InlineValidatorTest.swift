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
            value == "sha.kamel.eng@gmail.com" ? nil : "invalid"
        }
        validator.value = "sha.kamel.eng@gmail.com"
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        validator = InlineValidator { value in
            value == "x" ? nil : "invalid"
        }
        validator.value = "sha.kamel.eng"
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}