//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // 4
    @ObservedObject var formInfo = FormInfo()
    @State var isSaveDisabled = true

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Name")) {
                    TextField("First Name", text: $formInfo.firstName)
                            .validation(formInfo.firstNameValidation) // 5

                    TextField("Middle Names", text: $formInfo.middleNames)

                    TextField("Last Name", text: $formInfo.lastNames)
                            .validation(formInfo.lastNamesValidation)
                }

                Section(header: Text("Personal Information")) {
                    DatePicker(
                            selection: $formInfo.birthday,
                            displayedComponents: [.date],
                            label: { Text("Birthday") }
                    ).validation(formInfo.birthdayValidation)
                }

                Section(header: Text("Address")) {
                    TextField("Street Number or Name", text: $formInfo.house)
                            .validation(formInfo.street)

                    TextField("First Line", text: $formInfo.firstLine)
                            .validation(formInfo.streetValidation)

                    TextField("Second Line", text: $formInfo.secondLine)

                    TextField("Country", text: $formInfo.country)
                }

                Button(action: {
                   let valid = formInfo.form.triggerValidation()
                    print("Form valid: \(valid)")
//                    print(formInfo.form.allValidationMessagesString())
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
                    .onReceive(formInfo.form.$allValid) { isValid in
                        self.isSaveDisabled = !isValid
                    }
                    // React to validation messages changes
                    .onReceive(formInfo.form.$validationMessages) { messages in
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
