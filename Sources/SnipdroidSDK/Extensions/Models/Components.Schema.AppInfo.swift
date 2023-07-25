//
//  Components.Schema.AppInfo+Identifiable.swift
//  
//
//  Created by Butanediol on 2023/7/25.
//

import Foundation

extension Components.Schemas.AppInfo: Identifiable {}

extension Components.Schemas.AppInfo {
    /// A safe way to get tags.
    public var requireTags: [Components.Schemas.Tag] {
        self.tags ?? []
    }
}
