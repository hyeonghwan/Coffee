//
//  NetworkError.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/26.
//

import Foundation

enum NetworkError: Error{
    case decoding
    case encoding
    case wrongStatusCode
    case emptyData
    case unknownURL
    case unknown(Error)
}
