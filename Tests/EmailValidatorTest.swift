//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class EmailValidatorTest: XCTestCase {
    private var validator: EmailValidator!

    override func setUp() {
        validator = EmailValidator(errorMessage: "invalid")
    }

    func testValidator_shouldBeValid() {
        validator.value = "sha.kamel.eng@gmail.com"
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        validator.value = "sha.kamel.eng"
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}