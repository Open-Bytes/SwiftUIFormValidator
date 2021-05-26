//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class PatternValidatorTest: XCTestCase {
    private var validator: PatternValidator!

    override func setUp() {
        validator = PatternValidator(pattern: createPattern())

    }

    func testValidator_shouldBeValid() {
        let valid = validator.validate(value: "sh3ban.kamel@gmail.com", errorMessage: "invalid")
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        let valid = validator.validate(value: "sh3ban.kamel", errorMessage: "invalid")
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

    private func createPattern() -> NSRegularExpression {
        try! NSRegularExpression(
                pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$",
                options: .caseInsensitive)
    }

}