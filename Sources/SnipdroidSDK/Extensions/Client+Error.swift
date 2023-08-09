//
//  Client+Error.swift
//  
//
//  Created by Butanediol on 2023/8/9.
//

import Foundation

extension Client {
    enum Error: String, LocalizedError {
        case base64EncodingError
    }
}
