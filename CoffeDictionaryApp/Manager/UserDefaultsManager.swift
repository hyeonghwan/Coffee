//
//  Repository.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import Foundation

enum CoffeeKey: String{
    case coffees
}

class UserDefaultsManager {
    
    static let shared: UserDefaultsManager = UserDefaultsManager()
    
    let userDefault: UserDefaults = UserDefaults.standard
    
    private init(){
        
    }
    
    func storeAll(_ coffees: [Coffee]){
        do{
            let data = try PropertyListEncoder().encode(coffees)
            userDefault.set(data, forKey: CoffeeKey.coffees.rawValue)
            userDefault.synchronize()
        }catch{
            print("error 발생")
        }
    }
    
    
    func getCoffees() -> [Coffee]{
        if let nsData = userDefault.object(forKey: CoffeeKey.coffees.rawValue) as? NSData {
            print("저장된 data: \(nsData.description)")
            do {
                let coffeeList = try PropertyListDecoder().decode([Coffee].self, from: nsData as Data)
                return coffeeList.map({
                    if let star = $0.star {
                        return $0
                    }else{
                        return Coffee(id: $0.id, type_ID: $0.type_ID, title: $0.title, description: $0.description, image: $0.image, ingredients: $0.ingredients
                                      , star: false)
                    }
                    
                })
            } catch {
                print("error: \(error)")
            }
        }
        return []
    }
}
