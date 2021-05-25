//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine

public class FormValidation: ObservableObject {
    public var validators: [FormValidatorProtocol] = []

    @Published public var allValid: Bool = false

    public init() {

    }

    public func append(_ validator: FormValidatorProtocol) {
        var val = validator
        val.onChanged = onChanged
        validators.append(validator)
    }

    private func onChanged(validation: Validation) {
        allValid = isAllValid()
    }

    public func isAllValid() -> Bool {
        validators.first {
            !$0.latestValidation.isSuccess
        } == nil
    }
}