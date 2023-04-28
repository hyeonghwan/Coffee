//
//  NetworkService.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/19.
//

import Foundation


class NetworkService{
    static let shared = NetworkService()
    
    
    private let urlSession = URLSession(configuration: .default)
    
    private init(){
    }
    
    func cache(_ userDefault: UserDefaultsManager = UserDefaultsManager.shared,
                       completion: @escaping ((Result<[Coffee],NetworkError>) -> ())){
        let coffeelist = userDefault.getCoffees()
        
        if coffeelist.isEmpty{
            networkCall(completion)
        }else{
            completion(.success(coffeelist))
        }
    }
    
    private func networkCall(_ completion: @escaping ((Result<[Coffee],NetworkError>) -> ())){
        NetworkService.shared.getAllCoffeeList(completion: completion)
    }
    
    
    private func wiki_request(request: URLRequest,
                              _ completion: @escaping (Result<String,NetworkError>) -> Void ){
        urlSession.dataTask(with: request, completionHandler: { data, response, err in
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
                let model = try JSONDecoder().decode(WikiResponse.self, from: data)
                let json = try JSONSerialization.jsonObject(with: data)
                print("json: \(json)")
                print("data: \(model)")
            }catch{
                completion(.failure(.decoding))
                return
            }
        }).resume()
    }
    
    private func request(url request: URLRequest,
                         _ completion: @escaping (Result<String,NetworkError>) -> Void ){
        
        urlSession.dataTask(with: request, completionHandler: { data, response, err in
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
                let model = try JSONDecoder().decode(TranslateMessage.self, from: data)
                let tranResult = model.message.result.translatedText
                completion(.success(tranResult))
            }catch{
                completion(.failure(.decoding))
                return
            }
        }).resume()
    }
    
    private func request<Item : Decodable>(url: URL,
                                           _ method: String = "GET",
                                           _ body: [String : String] = [:],
                                           lastURLFlag: Bool = false,
                                           completion: @escaping (Result<[Item],NetworkError>,String?) -> Void)
    {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        if !body.isEmpty{
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body,
                                                          options: .prettyPrinted)
                urlRequest.httpBody = jsonData
            }catch{
                completion(.failure(.encoding),nil)
            }
        }
        
        urlSession.dataTask(with: urlRequest, completionHandler: { data, response, err in
            if let err {
                completion(.failure(.unknown(err)),nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300) ~= httpResponse.statusCode else {
                completion(.failure(.wrongStatusCode),nil)
                return
            }
            guard let data else {
                completion(.failure(.emptyData),nil)
                return
            }
            do {
                
                let models = try JSONDecoder().decode([Item].self, from: data)
                if lastURLFlag == true{
                    completion(.success(models),url.lastPathComponent)
                }else{
                    completion(.success(models),nil)
                }
            }catch{
                completion(.failure(.decoding),nil)
                return
            }
        }).resume()
    }
    
}


//MARK: CoffeeRequestable
extension NetworkService: CoffeeRequestable{
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
        
        
        // DispatchGroup Leave
        let receiveData: (Result<[Coffee],NetworkError>,String?) -> Void = { result,urlComponent in
            switch result{
            case .success(let success):
                let coffees = success.makeTypeID(urlComponent)
                coffee_model.append(contentsOf: coffees)
                group.leave()
            case .failure(let err):
                completion(.failure(err))
            }
        }
        
        // DispatchGroup Enter
        urls.forEach { url in
            group.enter()
            queue.async { [weak self] in
                guard let self else { return }
                self.request(url: url,lastURLFlag: true, completion: receiveData)
            }
        }
        
        group.notify(queue: .global(), work: work)
    }
    
    //.makeTypeID(url.lastPathComponent)))
    func getCoffeeList(type: CoffeeType,
                       completion: @escaping (Result<[Coffee],NetworkError>,String?) -> Void ){
        let url = endPoint(type)
        request(url: url, completion: completion)
    }
}

//MARK: wiki api request
extension NetworkService: WikiRequestable{
    func wikiRequest(_ coffee: Coffee, _ completion: @escaping (String) -> Void ){
        let title = coffee.title
        let description = coffee.description
        let url = endPoint(with: "wikiQA")
        
        var requestHeader: URLRequest = URLRequest(url: url)
        requestHeader.setValue(HTTPHeaderFields.application_json.string, forHTTPHeaderField: "Content-Type")
        requestHeader.setValue(Wiki_API_Key, forHTTPHeaderField: "Authorization")
        
        let type = "\(description)";            // 분석할 문단 데이터
        let question = "how make \(title)?";          // 질문 데이터
        
        let argument = Argument(type: type, question: question)
        
        do{
            requestHeader.httpMethod = "POST"
            requestHeader.httpBody = try JSONEncoder().encode(SendMessage(argument: argument))
        }catch{
            print("errrororororo: \(error)")
        }
        
        wiki_request(request: requestHeader, { result in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let failure):
                print("ffffff: \(failure)")
            }
        })
    }
}

//MARK: papago api request
extension NetworkService: PapagoRequestable{
    
    func translateRequest(_ coffee: Coffee,_ completion: @escaping (String) -> ()){
        let title = coffee.title
        let description = coffee.description
        let papagoURL = endPoint()
        
        var requestHeader: URLRequest = URLRequest(url: papagoURL)
        requestHeader.setValue(HTTPHeaderFields.encoded.string, forHTTPHeaderField: "Content-Type")
        requestHeader.setValue(X_Naver_Client_Id, forHTTPHeaderField: "X-Naver-Client-Id")
        requestHeader.setValue(X_Naver_Client_Secret, forHTTPHeaderField:"X-Naver-Client-Secret")
        
        let string = "source=en&target=ko&text=" + "\(title)!@#$\(description)"
        
        requestHeader.httpMethod = "POST"
        requestHeader.httpBody = string.data(using: .utf8)
        
        
        request(url: requestHeader, { result in
            
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let failure):
                print("ffffff: \(failure)")
            }
        })
    }
}
