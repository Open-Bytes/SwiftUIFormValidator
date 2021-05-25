//
// Created by Shaban on 24/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public typealias ValidationErrorClosure = () -> String

public protocol FormValidatorProtocol {
    var latestValidation: Validation { get set }
    var onChanged: ((Validation) -> Void)? { get set }
}

public protocol FormValidator: FormValidatorProtocol {
    associatedtype VALUE
    func validate(value: VALUE, errorMessage: @autoclosure @escaping ValidationErrorClosure) -> Validation
}