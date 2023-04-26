//
//  Array-ext.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import Foundation

extension Array where Element == Coffee {
    func makeTypeID(_ component: String?) -> Self{
        let maps = self.map{ coffee in
            return Coffee(type_ID: "\(component!)_\(coffee.id)",
                          id: coffee.id,
                          title: coffee.title,
                          description: coffee.description,
                          image: coffee.image,
                          ingredients: coffee.ingredients)
        }
        return maps
    }
}
