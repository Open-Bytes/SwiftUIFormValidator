//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class PrefixValidatorTest: XCTestCase {
    private var validator: PrefixValidator!

    func testValidator_shouldBeValid() {
        validator = PrefixValidator(prefix: "x")
        validator.value = "xcode"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_noIgnoreCase_shouldBeValid() {
        validator = PrefixValidator(prefix: "x", ignoreCase: false)
        validator.value = "xcode"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_noIgnoreCase_shouldNotBeValid() {
        validator = PrefixValidator(prefix: "x", ignoreCase: false)
        validator.value = "Xcode"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    func testValidator_shouldNotBeValid() {
        validator = PrefixValidator(prefix: "x")
        validator.value = "code"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}