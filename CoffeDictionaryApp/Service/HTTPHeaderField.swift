//
//  HTTPHeaderField.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/26.
//

import Foundation

enum HTTPHeaderFields {
    case application_json
    case encoded
    case none
    
    var string: String {
        switch self{
        case .application_json:
            return "application/json"
        case .encoded:
            return "application/x-www-form-urlencoded"
        case .none:
            return "none"
        }
    }
}
