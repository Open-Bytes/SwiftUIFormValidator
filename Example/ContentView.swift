//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // 4
    @ObservedObject var form = ExampleForm()
    @State var isSaveDisabled = true

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Name")) {
                    TextField("First Name", text: $form.firstName)
                            .validation(form.firstNameValidation) { message in
                                // Optionally provide your own custom error view.
                                Text(message.uppercased())
                                        .foregroundColor(Color.red)
                                        .font(.caption)
                            } // 5

                    TextField("Middle Names", text: $form.middleNames)

                    RoundedTextField(
                            "Last Name",
                            text: $form.lastNames,
                            validation: form.lastNamesValidation)
                }

                Section(header: Text("Password")) {
                    TextField("Password", text: $form.password)
                            .validation(form.passwordValidation)
                    TextField("Confirm Password", text: $form.confirmPassword)
                }

                Section(header: Text("Personal Information")) {
                    DatePicker(
                            selection: $form.birthday,
                            displayedComponents: [.date],
                            label: { Text("Birthday") }
                    ).validation(form.birthdayValidation)
                }

                Section(header: Text("Address")) {
                    TextField("Street Number or Name", text: $form.street)
                            .validation(form.streetValidation)

                    TextField("First Line", text: $form.firstLine)
                            .validation(form.firstLineValidation)

                    TextField("Second Line", text: $form.secondLine)

                    TextField("Country", text: $form.country)
                }

                Button(action: {
                    let valid = form.form.triggerValidation()
                    print("Form valid: \(valid)")
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
                    .navigationBarTitle("Form")
                    //                   observe the form validation and enable submit button only if it's valid
                    .onReceive(form.form.$allValid) { isValid in
                        self.isSaveDisabled = !isValid
                    }
                    // React to validation messages changes
                    .onReceive(form.form.$validationMessages) { messages in
                        print(messages)
                    }

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
