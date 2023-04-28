//
//  Array-ext.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element == Coffee {
    func makeTypeID(_ component: String?) -> Self{
        let maps = self.map{ coffee in
            return Coffee(id: "\(component!)_\(coffee.type_ID)",
                          type_ID: coffee.type_ID,
                          title: coffee.title,
                          description: coffee.description,
                          image: coffee.image,
                          ingredients: coffee.ingredients)
        }
        return maps
    }
}


