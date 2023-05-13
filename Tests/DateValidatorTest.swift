//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class DateValidatorTest: XCTestCase {
    private var validator: DateValidator!

    override func setUp() {
        validator = DateValidator(before: Date().dayAfter, after: Date().dayBefore, errorMessage: "invalid")
    }

    func testValidator_shouldBeValid() {
        validator.value = Date()
        let valid = validator.validate()
        XCTAssertEqual(valid, .success)
    }

    func testValidator_shouldNotBeValid() {
        let date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        validator.value = date
        let valid = validator.validate()
        XCTAssertEqual(valid, .failure(message: "invalid"))
    }

}

extension Date {
    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}