//
// Created by Shaban on 09/09/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

public enum Regex: String {
    case password = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
    case email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
}