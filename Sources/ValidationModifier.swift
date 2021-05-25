//
//  ValidationModifier.swift
//  SwiftUI-Validation
//
// Created by Shaban on 24/05/2021.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import Foundation
import SwiftUI

public struct ValidationModifier: ViewModifier {
    @State var latestValidation: Validation = .success

    public let publisher: ValidationPublisher

    public init(publisher: ValidationPublisher) {
        self.publisher = publisher
    }

    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            validationMessage
        }.onReceive(publisher) { validation in
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

public extension View {

    func validation(_ validationPublisher: ValidationPublisher) -> some View {
        self.modifier(ValidationModifier(publisher: validationPublisher))
    }

}
