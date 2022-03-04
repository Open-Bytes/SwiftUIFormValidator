//
// Created by Shaban Kamel on 04/03/2022.
// Copyright (c) 2022 sha. All rights reserved.
//

import SwiftUI
import FormValidator

/// This is an example for demonstrating the ability to display the error view
/// in any place you need. In this example, the error view is displayed inside the rounded
/// stroke of the view NOT outside the stroke. We have implemented this by putting the
/// validation modifier before the background.
struct RoundedTextField: View {
    let titleKey: LocalizedStringKey
    let text: Binding<String>
    let validation: ValidationContainer

    init(_ titleKey: LocalizedStringKey,
         text: Binding<String>,
         validation: ValidationContainer) {
        self.titleKey = titleKey
        self.text = text
        self.validation = validation
    }

    var body: some View {
        TextField(titleKey, text: text)
                .validation(validation)
                .frame(height: 40)
                .padding()
                .background(
                        RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.primary, lineWidth: 2)
                                .background(
                                        RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.white)
                                )
                )
    }
}
