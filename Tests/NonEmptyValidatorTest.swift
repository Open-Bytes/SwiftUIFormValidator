//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class NonEmptyValidatorTest: XCTestCase {
    private var validator: NonEmptyValidator!

    override func setUp() {
        validator = NonEmptyValidator()
    }

    func testValidator_shouldBeValid() {
        let valid = validator.validate(value: "sh3ban.kamel@gmail.com", errorMessage: "invalid")
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        let valid = validator.validate(value: "", errorMessage: "invalid")
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}