//
// Created by Shaban on 13/05/2023.
// Copyright (c) 2023 sha. All rights reserved.
//

import Foundation

struct ErrorFormatter {

    static func format(errors: [String]) -> String {
        errors.joined(separator: "\n")
    }
}
