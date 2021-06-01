//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class PasswordValidatorTest: XCTestCase {
    private var validator: PasswordValidator!

    func testValidator_matching_shouldBeValid() {
        validator = PasswordValidator(firstPassword: "123", secondPassword: "123")
        validator.value = ValidatedPassword(password: "123", type: 0)
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_matching_shouldNotBeValid() {
        validator = PasswordValidator(firstPassword: "123", secondPassword: "123")
        validator.value = ValidatedPassword(password: "12", type: 0)
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    func testValidator_pattern_shouldBeValid() {
        let pattern = try! NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-_~!*()]).{8,}$")
        validator = PasswordValidator(firstPassword: "123SSss@ffkf#", secondPassword: "123SSss@ffkf#", pattern: pattern)
        validator.value = ValidatedPassword(password: "123SSss@ffkf#", type: 0)
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_pattern_shouldNotBeValid() {
        let pattern = try! NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=-_~!*()]).{8,}$")
        validator = PasswordValidator(firstPassword: "123456", secondPassword: "123456", pattern: pattern)
        validator.value = ValidatedPassword(password: "123456", type: 0)
        validator.errorMessage = {
            "invalid"
        }
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }
}