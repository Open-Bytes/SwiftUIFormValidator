//
// Created by Shaban on 31/10/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import SwiftUI
import FormValidator

struct FormTextField: View {
    @Binding private var text: String
    private let placeholder: String?
    private let validation: ValidationContainer

    init(
            text: Binding<String>,
            placeholder: String? = nil,
            validation: ValidationContainer
    ) {
        _text = text
        self.placeholder = placeholder
        self.validation = validation
    }

    var body: some View {
        FormUITextField(
                text: $text,
                placeholder: placeholder,
                onCommit: {
                    // Trigger the validation
                    validation.validate()
                },
                onLostFocus: {
                    validation.validate()
                },
                onReturnClicked: {
                    validation.validate()
                })
                .validation(validation)
    }
}

struct FormUITextField: UIViewRepresentable {
    @Binding private var text: String
    private var placeholder: String?
    private let onEditingChanged: (() -> Void)?
    private let onCommit: (() -> Void)?
    private let onLostFocus: (() -> Void)?
    private let onReturnClicked: (() -> Void)?

    init(
            text: Binding<String>,
            placeholder: String?,
            setup: ((UITextField) -> Void)? = nil,
            onEditingChanged: (() -> Void)? = nil,
            onCommit: (() -> Void)? = nil,
            onLostFocus: (() -> Void)? = nil,
            onReturnClicked: (() -> Void)? = nil
    ) {
        _text = text
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.onLostFocus = onLostFocus
        self.onReturnClicked = onReturnClicked
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidEndEditing(_:)), for: .editingDidEnd)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidReturn(_:)), for: .editingDidEndOnExit)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: FormUITextField

        init(_ parent: FormUITextField) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
            parent.onEditingChanged?()
        }

        @objc func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onCommit?()
        }

        @objc func textFieldDidReturn(_ textField: UITextField) {
            parent.onReturnClicked?() // Call the closure when return button is clicked
        }

        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            switch reason {
            case .committed:
                parent.onLostFocus?()
            @unknown default:
                break
            }
        }
    }
}