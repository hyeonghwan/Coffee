//
//  ObservableObject.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import Foundation
import Combine


class NetworkObservable: ObservableObject{
    
    @Published var coffeeList: [Coffee] = []
    
    static var shared: NetworkObservable = NetworkObservable()
    
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var allCompletion: (Result<[Coffee],NetworkError>) -> () = { [weak self] result in
        guard let self else {return}
        switch result{
        case .success(let coffees):
            DispatchQueue.main.async { [weak self] in
                guard let self else {return}
                self.coffeeList.append(contentsOf: coffees)
            }
        case .failure(let err):
            assert(false, "\(err)")
        }
    }
    
    private init(){
        $coffeeList
            .filter({ element in !element.isEmpty})
            .sink(receiveValue: { coffees in
                UserDefaultsManager.shared.storeAll(coffees)
            })
            .store(in: &subscriptions)
    }
    
    func getAllCoffeeList(){
        NetworkService.shared.cache(completion: allCompletion)
    }
   
}
