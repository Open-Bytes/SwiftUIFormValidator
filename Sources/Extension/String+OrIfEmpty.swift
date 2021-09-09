//
// Created by Shaban on 09/09/2021.
// Copyright (c) 2021 sha. All rights reserved.
//

import Foundation

extension String {
    func orIfEmpty(_ other: String) -> String {
        guard !isEmpty else {
            return other
        }
        return self
    }
}