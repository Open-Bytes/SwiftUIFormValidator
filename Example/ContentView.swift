//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import SwiftUI
import FormValidator

struct ContentView: View {
    @ObservedObject var form = ExampleForm()
    @State var isSaveDisabled = true

    var body: some View {
        NavigationView {
            Form {
                RequiredFieldsValidationSection()
                InlineValidationSection()
                CountValidationSection()
                CompositeValidationAllSection()
                CompositeValidationAnySection()
                PasswordMatchingSection()
                DateValidationSection()
                CustomErrorViewSection()
                CustomFieldUISection()
                CompanyField()

                SubmitButton()
            }
                    .navigationBarTitle("Form Validator")
                    //                   observe the form validation and enable submit button only if it's valid
                    .onReceive(form.manager.$allValid) { isValid in
                        self.isSaveDisabled = !isValid
                    }
                    // React to validation messages changes
                    .onReceive(form.manager.$validationMessages) { messages in
                        print(messages)
                    }

        }
    }

    private func RequiredFieldsValidationSection() -> some View {
        Section(header: Text("Required Fields Validation")) {
            TextField("First Name", text: $form.firstName)
                    .validation(form.firstNameValidation)
        }
    }

    private func InlineValidationSection() -> some View {
        Section(header: Text("Inline Validation")) {
            TextField("Age",
                    value: $form.age,
                    format: .number)
                    .validation(form.ageValidation)
        }
    }

    private func PasswordMatchingSection() -> some View {
        Section(header: Text("Password Matching Validation")) {
            TextField("Password", text: $form.password)
                    .validation(form.passwordValidation)
            TextField("Confirm Password", text: $form.confirmPassword)
                    .validation(form.passwordValidation)
        }
    }

    private func DateValidationSection() -> some View {
        Section(header: Text("Date Validation")) {
            DatePicker(
                    selection: $form.birthday,
                    displayedComponents: [.date],
                    label: { Text("Birthday") }
            ).validation(form.birthdayValidation)
        }
    }

    private func CountValidationSection() -> some View {
        Section(header: Text("Count Validation")) {
            TextField("First Line", text: $form.firstLine)
                    .validation(form.firstLineValidation)
        }
    }

    private func CompositeValidationAllSection() -> some View {
        Section(header: Text("Composite Validation (All)")) {
            Text("All validations are required. The field must start with the letter 'n' and be at least 6 characters long.")
                    .foregroundColor(Color.green)
            TextField("Address", text: $form.address)
                    .validation(form.addressValidation)
        }
    }

    private func CompositeValidationAnySection() -> some View {
        Section(header: Text("Composite Validation (Any)")) {
            Text("At least one validation is required. The field must start with the letter 'n' or be at least 6 characters long.")
                    .foregroundColor(Color.green)
            TextField("Street", text: $form.street)
                    .validation(form.streetValidation)
        }
    }

    private func CustomErrorViewSection() -> some View {
        Section(header: Text("Customizing the error view")) {
            TextField("City", text: $form.city)
                    .validation(form.cityValidation) { message in
                        Text(message.uppercased())
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                    }
        }
    }

    private func CustomFieldUISection() -> some View {
        Section(header: Text("Customizing the UI for TextField validation")) {
            RoundedTextField(
                    "Last Name",
                    text: $form.lastName,
                    validation: form.lastNameValidation)
        }
    }

    private func CompanyField() -> some View {
        Section(header: Text("Triggering validation on lose the focus of the text field")) {
            FormTextField(
                    text: $form.company,
                    placeholder: "Company",
                    validation: form.companyValidation)
        }
    }

    private func SubmitButton() -> some View {
        Button(action: {
            validateForm()
        }, label: {
            HStack {
                Text("Submit")
                Spacer()
                Image(systemName: "checkmark.circle.fill")
            }
        })
//                You can disable the button, and only enable it when the form is valid
//                        .disabled(isSaveDisabled)
    }

    private func validateForm() {
        // Validate the main form
        let valid = form.manager.triggerValidation()
        // Validate company form
        let isCompanyValid = form.companyFormManager.triggerValidation()

        // Validation result.
        print("Form valid: \(valid)")

        // Another way for checking validation.
        print("Is all valid: \(form.manager.isAllValid())")

        // Check if all fields have text. This is not validation check.
        print("Is all filled: \(form.manager.isAllFilled())")

        // Get an array with all validation messages.
        print("All validation messages array: \(form.manager.validationMessages)")

        // Get error messages as string, separated with a new line.
        print("All validation messages string: \(form.manager.errorsDescription())")
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
