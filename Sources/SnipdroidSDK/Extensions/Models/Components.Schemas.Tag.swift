//
//  Components.Schemas.Tag.swift
//  
//
//  Created by Butanediol on 2023/7/25.
//

import Foundation
import OpenAPIRuntime

extension Components.Schemas.Tag: Comparable, Identifiable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name
    }
}
