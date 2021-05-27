SwiftUIFormValidator
================
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

A declarative **SwiftUI** form validation. Clean, simple, and customizable.

- [Usage](#usage)
  - [Basic Setup](#basic-setup)
  - [Validation Types](#validation-types)
  - [Inline Validation](#inline-validation)
  - [Manual Validation](#manual-validation)
  - [React to Validation Change](#react-to-validation-change)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Swift Package Manager](#swift-package-manager)
  - [Accio](#accio)
  - [Carthage](#carthage)
- [Validators](#validators)
- [Custom Validators](#custom-validators)
- [Validation Messages](#validation-messages)
- [Contribution](#contribution)
- [License](#license)

## Usage

### Basic Setup
```
  import FormValidator
  
  // 1
  class FormInfo: ObservableObject {
      @Published var firstName: String = ""
       // 2
      lazy var form = {
          FormValidation(validationType: .immediate)
      }()
       // 3
      lazy var firstNameValidation: ValidationContainer = {
          $firstName.nonEmptyValidator(form: form, errorMessage: "First name is not valid")
      }()
      
  struct ContentView: View {
      // 4
      @ObservedObject var formInfo = FormInfo()
      
      var body: some View {
           TextField("First Name", text: $formInfo.firstName)
               .validation(formInfo.firstNameValidation) // 5
      }
  }
```

1. Import `FormValidator`.
2. Declare an `ObservableObject` for the form with any name, for example, FormInfo, LoginInfo, or any name.
3. Declare `FormValidation` object and choose a validation type.
4. Declare a `ValidationContainer` for the field you need to validate.
5. In your view, declare the `FormValidation` object.
6. Declare `validation(formInfo.firstNameValidation)` with the validation of the field.

**Congratulation!!** your field is now validated for you!

### Inline Validation

For fast validation, you can use `InlineValidator` and provide your validation logic in line:

```swift
 lazy var lastNamesValidation: ValidationContainer = {
        $lastNames.inlineValidator(form: form) { value in
          // Put validation logic here
            !value.isEmpty
        }
    }()
```

### Validation Types

You can choose between 2 different validation types: `FormValidation(validationType: .immediate)` and `FormValidation(validationType: .deffered)`

1. **immediate**: the validation is triggered every time the field is changed. An error
  message will be shown in case the value is invalid.
2. **deferred**: in this case, the validation will be triggered manually only using `FormValidation.triggerValidation()`
  The error messages will be displayed only after triggering the validation manually.

### Manual Validation

You can trigger the form validation any time by calling `FormValidation.triggerValidation()`. After the validation, each field in the form will
display error message if it's invalid.

### React to Validation Change

You can react to validation change using `FormValidation.$allValid` and `FormValidation.$validationMessages`

```
VStack {} // parent view of the form
      .onReceive(formInfo.form.$allValid) { isValid in self.isSaveDisabled = !isValid }
      .onReceive(formInfo.form.$validationMessages) { messages in print(messages) }
```

## Installation

### CocoaPods

Use the following entry in your Podfile:

```rb
pod 'SwiftUIFormValidator'
```

Then run `pod install`.


### Swift Package Manager

Add the following as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/ShabanKamell/SwiftUIFormValidator.git")
```

and then specify `"SwiftUIFormValidator"` as a dependency of the Target in which you wish to use SwiftUIFormValidator.
Here's an example `PackageDescription`:

```swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MyPackage",
    products: [
        .library(
            name: "MyPackage",
            targets: ["MyPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ShabanKamell/SwiftUIFormValidator")
    ],
    targets: [
        .target(
            name: "MyPackage",
            dependencies: ["SwiftUIFormValidator"])
    ]
)
```

### Accio

[Accio](https://github.com/JamitLabs/Accio) is a dependency manager based on SwiftPM which can build frameworks for iOS/macOS/tvOS/watchOS. Therefore the integration steps of SwiftUIFormValidator are exactly the same as described above. Once your `Package.swift` file is configured, run `accio update` instead of `swift package update`.

Don't forget to add `import FormValidator` to use the framework.

### Carthage

Carthage users can point to this repository and use generated `SwiftUIFormValidator` framework.

Make the following entry in your Cartfile:

```
github "ShabanKamell/SwiftUIFormValidator"
```

Then run `carthage update`.

If this is your first time using Carthage in the project, you'll need to go through some additional steps as explained [over at Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

## Validators

|       **Validator**       |                    **Description**                         |
| ------------------------- | -----------------------------------------------------------|
|   **NonEmptyValidator**   | Validates if a string is empty of blank                    |
|   **EmailValidator**      | Validates if the email is valid or not.                    |
|   **DateValidator**       | Validates if a date falls within `after` & `before` dates. |
|   **PatternValidator**    | Validates if a patten is matched or not.                   |
|   **InlineValidator**     | Validates if a condition is valid or not.                  |

## Custom Validators
In easy steps, you can add a custom validator:
```
// 1
class CountValidator: FormValidator {
    public var publisher: ValidationPublisher!
    public var subject: ValidationSubject = .init()
    public var latestValidation: Validation = .failure(message: "")
    public var onChanged: ((Validation) -> Void)? = nil

    func validate(
            value: String,
            errorMessage: @autoclosure @escaping ValidationErrorClosure
    ) -> Validation {
        guard value.count == 2 else {
            return .failure(message: errorMessage())
        }
        return .success
    }
}

// 2
public extension Published.Publisher where Value == String {
    func countValidator(
            form: FormValidation,
            errorMessage: @autoclosure @escaping ValidationErrorClosure = ""
    ) -> ValidationContainer {
        let validator = CountValidator()
        let message = errorMessage()
        return ValidationPublishers.create(
                form: form,
                validator: validator,
                for: self,
                errorMessage: !message.isEmpty ? message : "Count must be 2")
    }
}
```

1. Implement `FormValidator` protocol.
2. Add the validator logic in an extension to `Published.Publisher`.

## Validation Messages

You can provide a validation message for every field by providing `errorMessage`

```swift
$firstName.nonEmptyValidator(form: form, errorMessage: "First name is not valid")
```

If you don't provide a message, a default one will be used for built-in providers.
All default messages are located in `DefaultValidationMessages` class.

```swift
$firstName.nonEmptyValidator(form: form) // will use the default message
```

In this example, `DefaultValidationMessages.required` will be used.

### Overriding Default Validation Messages

You can override the default validation messages by inheriting from `DefaultValidationMessages`

```swift
class ValidationMessages: DefaultValidationMessages {
    public override var required: String {
        "Required field"
    }
  // Override any message ...
}
```

Or if you need to override all the messages, you can implement `ValidationMessagesProtocol`.

And provide the messages to `FormValidation`

```swift
FormValidation(validationType: .immediate, messages: ValidationMessages())
```

## Credit

[Validation with SwiftUI & Combine](https://newcombe.io/2020/03/05/validation-with-swiftui-combine-part-1/)

## Contribution

All PRs are welcome. Help us make this library better.

## License

<details>
    <summary>
        click to reveal License
    </summary>

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

</details>
