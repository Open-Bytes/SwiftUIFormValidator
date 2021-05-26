//
// Created by Shaban on 26/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import XCTest
import FormValidator

class DateValidatorTest: XCTestCase {
    private var validator: DateValidator!

    override func setUp() {
        validator = DateValidator(before: Date().dayBefore, after: Date().dayAfter)
    }

    func testValidator_shouldBeValid() {
        let valid = validator.validate(value: Date(), errorMessage: "invalid")
        XCTAssertEqual(valid, .success)
    }
    func testValidator_shouldNotBeValid() {
        let date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let valid = validator.validate(value: date, errorMessage: "invalid")
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