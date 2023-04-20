//
//  NetworkService.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/19.
//

import Foundation


class NetworkService: APIRequestURL{
    
    enum NetworkError: Error{
        case decoding
        case encoding
        case wrongStatusCode
        case emptyData
        case unknownURL
        case unknown(Error)
    }
    
    static let shared = NetworkService()
    
    
    private let urlSession = URLSession(configuration: .default)
    
   
    private init(){
    }
    

    private func endPoint(_ type: CoffeeType) -> URL{
        guard
            let url = self.makeEndPoint(type: type)
        else {
            assert(false, "failed make EndPoint")
        }
        return url
    }
    
    func getAllCoffeeList(completion: @escaping (Result<[Coffee],NetworkError>) -> Void){
        
        var urls: [URL] = []
        CoffeeType.allCases.forEach{ type in
            urls.append(endPoint(type))
        }
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "serial")
        var coffee_model: [Coffee] = []
        
        let work = DispatchWorkItem(block: {
            completion(.success(coffee_model))
        })
        
        let receiveData: (Result<[Coffee],NetworkError>) -> Void = { result in
            switch result{
            case .success(let success):
                coffee_model.append(contentsOf: success)
                group.leave()
            case .failure(let err):
                completion(.failure(err))
            }
        }
        
        urls.forEach { url in
            group.enter()
            queue.async { [weak self] in
                guard let self else { return }
                self.request(url: url, completion: receiveData)
            }
        }
        
        group.notify(queue: .global(), work: work)
    }
    
    
    func getCoffeeList(type: CoffeeType,
                       completion: @escaping (Result<[Coffee],NetworkError>) -> Void ){
        let url = endPoint(type)
        request(url: url, completion: completion)
    }
    
    
    
    
    private func request(url: URL,
                         _ method: String = "GET",
                         _ body: [String : String] = [:],
                         completion: @escaping (Result<[Coffee],NetworkError>) -> Void )
    {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        if !body.isEmpty{
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body,
                                                          options: .prettyPrinted)
                urlRequest.httpBody = jsonData
            }catch{
                completion(.failure(.encoding))
            }
        }
        
        urlSession.dataTask(with: urlRequest, completionHandler: { data, response, err in
            if let err {
                completion(.failure(.unknown(err)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300) ~= httpResponse.statusCode else {
                completion(.failure(.wrongStatusCode))
                return
            }
            guard let data else {
                    completion(.failure(.emptyData))
                return
            }
            do {
                let models = try JSONDecoder().decode([Coffee].self, from: data)
                completion(.success(models.makeTypeID(url.lastPathComponent)))
            }catch{
                completion(.failure(.decoding))
                return
            }
        }).resume()
    }
    
}
