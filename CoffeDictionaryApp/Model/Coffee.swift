//
//  Coffe.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/19.
//

import Foundation



enum CoffeeType: CaseIterable{
    typealias URL = String
    
    case IceCoffee
    case HotCoffee
    
    enum Key: String{
        case IceCoffee
        case HotCoffee
    }
}


struct Coffee: Codable,Identifiable{
    typealias Identifier = String
    let id: Identifier?
    let type_ID: Int
    let title: String
    let description: String
    let image: String
    let ingredients: [String]
    var star: Bool? = false
    
    enum CodingKeys: String,CodingKey{
        case id = "type_ID"
        case type_ID = "id"
        case title
        case description
        case image
        case ingredients
        case star
    }
}
