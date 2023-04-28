//
//  TranslateMessage.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import Foundation


struct TranslateMessage: Decodable{
    let message: Message
}

struct Message: Decodable{
    var result: PapagoResult
}

struct PapagoResult: Decodable{
    let engineType: String
    var srcLangType: String
    var tarLangType: String
    var translatedText: String
}
