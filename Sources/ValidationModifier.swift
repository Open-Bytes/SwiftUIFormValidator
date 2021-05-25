//
//  ValidationModifier.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Sha. All rights reserved.
//

import Foundation
import SwiftUI

public struct ValidationContainer {
    public let publisher: ValidationPublisher
    public let subject: ValidationSubject
}

public extension View {

    func validation(_ container: ValidationContainer) -> some View {
        self.modifier(ValidationModifier(container: container))
    }

}

public struct ValidationModifier: ViewModifier {
    @State var latestValidation: Validation = .success

    public let container: ValidationContainer

    public init(container: ValidationContainer) {
        self.container = container
    }

    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(container.publisher) { validation in
            self.latestValidation = validation
        }.onReceive(container.subject) { validation in
            self.latestValidation = validation
        }
    }

    public var validationMessage: some View {
        switch latestValidation {
        case .success:
            return AnyView(EmptyView())
        case .failure(let message):
            let text = Text(message)
                    .foregroundColor(Color.red)
                    .font(.caption)
            return AnyView(text)
        }
    }
}
