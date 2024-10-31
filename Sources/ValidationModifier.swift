//
//  ValidationModifier.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Sha. All rights reserved.
//

import Foundation
import SwiftUI

public typealias ValidationErrorView<ErrorView: View> = (_ message: String) -> ErrorView

public struct ValidationContainer {
    public let validator: any Validatable
    public let publisher: ValidationPublisher
    public let subject: ValidationSubject

    public func validate(isDisabled: Bool = false, shouldShowError: Bool = true) {
        validator.triggerValidation(
                isDisabled: isDisabled,
                shouldShowError: shouldShowError)
    }
}

public extension View {

    ///A modifier used for validating a root publisher.
    /// Whenever the publisher changes, the value will be validated
    /// and propagated to this view.
    /// In case it's invalid, an error message will be displayed under the view
    ///
    /// - Parameter container: the validation container.
    /// - Parameter errorView: the view displaying the validation message.
    ///   - errorView: a custom error view
    /// - Returns: a view after applying the validation modifier
    func validation<ErrorView: View>(
            _ container: ValidationContainer?,
            errorView: ValidationErrorView<ErrorView>? = nil) -> some View {
        guard let container = container else {
            return eraseToAnyView()
        }
        let validationModifier = ValidationModifier(container: container, errorView: errorView)
        return modifier(validationModifier).eraseToAnyView()
    }

    ///A modifier used for validating a root publisher.
    /// Whenever the publisher changes, the value will be validated
    /// and propagated to this view.
    /// In case it's invalid, an error message will be displayed under the view
    ///
    /// - Parameter container: the validation container
    /// - Returns: a view after applying the validation modifier
    func validation(_ container: ValidationContainer?) -> some View {
        guard let container = container else {
            return eraseToAnyView()
        }
        let validationModifier = ValidationModifier<EmptyView>(container: container, errorView: nil)
        return modifier(validationModifier).eraseToAnyView()
    }

}

/// A modifier for applying the validation to a view.
public struct ValidationModifier<ErrorView: View>: ViewModifier {
    @State var latestValidation: Validation = .success

    public let container: ValidationContainer
    private let errorView: ValidationErrorView<ErrorView>?

    public init(
            container: ValidationContainer,
            errorView: ValidationErrorView<ErrorView>? = nil) {
        self.container = container
        self.errorView = errorView
    }

    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(container.publisher.removeDuplicates()) { validation in
            self.latestValidation = validation
        }.onReceive(container.subject.removeDuplicates()) { validation in
            self.latestValidation = validation
        }
    }

    public var validationMessage: some View {
        switch latestValidation {
        case .success:
            return EmptyView().eraseToAnyView()
        case .failure(let message):
            guard let view = errorView?(message) else {
                let text = Text(message)
                        .foregroundColor(Color.red)
                        .font(.system(size: 14))
                return text.eraseToAnyView()
            }
            return view.eraseToAnyView()
        }
    }
}
