//
// Created by Shaban on 25/05/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var formInfo = FormInfo()
    @State var isSaveDisabled = true

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Name")) {
                    TextField("First Name", text: $formInfo.firstName)
                            .validation(formInfo.firstNameValidation) // 4

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
                    TextField("Street Number or Name", text: $formInfo.addressHouseNumberOrName)
                            .validation(formInfo.street)

                    TextField("First Line", text: $formInfo.addressFirstLine)
                            .validation(formInfo.streetValidation)

                    TextField("Second Line", text: $formInfo.addressSecondLine)

                    TextField("Country", text: $formInfo.addressCountry)
                }

                Button(action: {
                    print(formInfo.form.allValidationMessagesString())
                }, label: {
                    HStack {
                        Text("Submit")
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                    }
                }).disabled(isSaveDisabled)

            }
                    .navigationBarTitle("Form")
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
