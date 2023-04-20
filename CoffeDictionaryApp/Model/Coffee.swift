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

struct Coffee: Decodable{
    typealias Identifier = String
    let type_ID: Identifier?
    let id: Int
    let title: String
    let description: String
    let image: String
    let ingredients: [String]
}
