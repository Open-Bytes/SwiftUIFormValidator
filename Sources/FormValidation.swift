//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Combine

public class FormValidation: ObservableObject {
    public var validators: [FormValidatorProtocol] = []

    @Published public var allValid: Bool = false
    @Published public var validationMessages: [String] = []

    public let validationType: ValidationType
    public let subject = ValidationSubject()


    public init(validationType: ValidationType) {
        self.validationType = validationType
    }

    public func append(_ validator: FormValidatorProtocol) {
        var val = validator
        val.onChanged = onChanged
        validators.append(validator)
    }

    private func onChanged(validation: Validation) {
        allValid = isAllValid()
        validationMessages = allValidationMessages()
    }

    public func isAllValid() -> Bool {
        validators.first {
            !$0.latestValidation.isSuccess
        } == nil
    }

    public func allValidationMessagesString() -> String {
        allValidationMessages().joined(separator: "\n")
    }

    public func allValidationMessages() -> [String] {
        validators.compactMap {
            switch $0.latestValidation {
            case .success: return nil
            case .failure(let message): return message.isEmpty ? nil : message
            }
        }
    }

    public func triggerValidation() -> Bool {
        switch validationType {
        case .immediate: break
        case .deferred:
            validators.forEach {
                $0.triggerValidation()
            }
        }
        return isAllValid()
    }
}

public extension FormValidation {

    enum ValidationType {
        case immediate
        case deferred
    }

}