//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class CountValidatorTest: XCTestCase {
    private var validator: CountValidator!

    func testValidator_equals_shouldBeValid() {
        let valid = validate(value: "12", count: 2, type: .equals)
        XCTAssertEqual(valid, .success)
    }

    func testValidator_equals_shouldNotBeValid() {
        let valid = validate(value: "121", count: 2, type: .equals)
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    func testValidator_lessThan_shouldBeValid() {
        let valid = validate(value: "1", count: 2, type: .lessThan)
        XCTAssertEqual(valid, .success)
    }

    func testValidator_lessThan_shouldNotBeValid() {
        let valid = validate(value: "12", count: 2, type: .lessThan)
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    func testValidator_lessThanOrEquals_shouldBeValid() {
        let valid = validate(value: "12", count: 2, type: .lessThanOrEquals)
        XCTAssertEqual(valid, .success)
    }

    func testValidator_lessThanOrEquals_shouldNotBeValid() {
        let valid = validate(value: "121", count: 2, type: .lessThanOrEquals)
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    func testValidator_greaterThanOrEquals_shouldBeValid() {
        let valid = validate(value: "121", count: 2, type: .greaterThan)
        XCTAssertEqual(valid, .success)
    }

    func testValidator_greaterThanOrEquals_shouldNotBeValid() {
        let valid = validate(value: "12", count: 2, type: .greaterThan)
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    func testValidator_greaterThan_shouldBeValid() {
        let valid = validate(value: "12", count: 2, type: .greaterThanOrEquals)
        XCTAssertEqual(valid, .success)
    }

    func testValidator_greaterThan_shouldNotBeValid() {
        let valid = validate(value: "1", count: 2, type: .greaterThanOrEquals)
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    private func validate(value: String, count: Int, type: CountValidator.ValidationType) -> Validation {
        validator = CountValidator(count: count, type: type, errorMessage: "invalid")
        validator.value = value
        return validator.validate()
    }
}