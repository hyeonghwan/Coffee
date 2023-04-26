//
//  EndPoint.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import Foundation




protocol APIRequestURL{
    
}

protocol CoffeeRequestable: APIRequestURL{
    func getAllCoffeeList(completion: @escaping (Result<[Coffee],NetworkError>) -> Void)
    func getCoffeeList(type: CoffeeType,
                       completion: @escaping (Result<[Coffee],NetworkError>,String?) -> Void )
}

//MARK: - Coffe URL
extension CoffeeRequestable{
    
    func endPoint(_ type: CoffeeType) -> URL{
        guard
            let url = self.makeEndPoint(type: type)
        else {
            assert(false, "failed make EndPoint")
        }
        return url
    }
    
    private var ice: String{
        guard
            let url = Bundle.main.infoDictionary?["Ice"] as? String
        else {
            return ""
        }
        return url
    }
    
    private  var hot: String{
        guard
            let url = Bundle.main.infoDictionary?["Hot"] as? String
        else {
            return ""
        }
        return url
    }
    
    private func makeEndPoint(type: CoffeeType) -> URL?{
        switch type {
        case .IceCoffee:
            return URL(string: ice)
        case .HotCoffee:
            return URL(string: hot)
        }
    }
}

//MARK: -Papago URL

protocol PapagoRequestable: APIRequestURL{
    
}

extension PapagoRequestable{
    
    
    /// Papago API End Point
    /// - Returns: resource URL
    func endPoint() -> URL{
        guard
            let url = URL(string: papagoAPIResource)
        else {
            assert(false, "failed make EndPoint")
        }
        return url
    }
    
    private var papagoAPIResource: String{
        guard
            let url = Bundle.main.infoDictionary?["PapagoAPIResource"] as? String
        else {
            return ""
        }
        return url
    }
    
    var X_Naver_Client_Secret: String{
        guard
            let url = Bundle.main.infoDictionary?["X_Naver_Client_Secret"] as? String
        else {
            return ""
        }
        return url
    }
    
    var X_Naver_Client_Id: String{
        guard
            let url = Bundle.main.infoDictionary?["X_Naver_Client_Id"] as? String
        else {
            return ""
        }
        return url
    }
    
    
    
}
