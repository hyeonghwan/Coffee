//
//  EndPoint.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import Foundation

protocol APIRequestURL{
    
}

extension APIRequestURL{
    var ice: String{
        guard
            let url = Bundle.main.infoDictionary?["Ice"] as? String
        else {
            return ""
        }
        return url
    }
    
    var hot: String{
        guard
            let url = Bundle.main.infoDictionary?["Hot"] as? String
        else {
            return ""
        }
        return url
    }
    
    func makeEndPoint(type: CoffeeType) -> URL?{
        switch type {
        case .IceCoffee:
            return URL(string: ice)
        case .HotCoffee:
            return URL(string: hot)
        }
    }
}
