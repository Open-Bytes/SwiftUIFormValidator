//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public protocol ValidationMessagesProtocol {
    var required: String { get }
    var invalidPattern: String { get }
    var invalidEmailAddress: String { get }
    var invalidDate: String { get }
    var passwordsNotMatching: String { get }
}

open class DefaultValidationMessages: ValidationMessagesProtocol {
    public init() {
    }

    open var required: String {
        "Required"
    }

    open var invalidPattern: String {
        "Invalid pattern"
    }

    open var invalidEmailAddress: String {
        "Invalid email address"
    }

    open var invalidDate: String {
        "Invalid date"
    }

    open var passwordsNotMatching: String {
        "Passwords don't match"
    }

}
