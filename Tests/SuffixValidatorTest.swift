//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class SuffixValidatorTest: XCTestCase {
    private var validator: SuffixValidator!

    func testValidator_shouldBeValid() {
        validator = SuffixValidator(suffix: "e")
        validator.value = "xcode"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_noIgnoreCase_shouldBeValid() {
        validator = SuffixValidator(suffix: "e", ignoreCase: false)
        validator.value = "xcode"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_noIgnoreCase_shouldNotBeValid() {
        validator = SuffixValidator(suffix: "e", ignoreCase: false)
        validator.value = "XcodE"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    func testValidator_shouldNotBeValid() {
        validator = SuffixValidator(suffix: "e")
        validator.value = "Xcodes"
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}