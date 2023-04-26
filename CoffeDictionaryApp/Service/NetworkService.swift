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
    
    private func request(url request: URLRequest,
                         _ completion: @escaping (Result<String,NetworkError>) -> Void ){
        
        urlSession.dataTask(with: request, completionHandler: { data, response, err in
            if let err {
                completion(.failure(.unknown(err)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300) ~= httpResponse.statusCode else {
                let t = response as? HTTPURLResponse
                
                print("response: \(t)")
                print("eeeeee: \(err)")
                print("httpResponse.statusCode : \(t?.statusCode)")
                completion(.failure(.wrongStatusCode))
                return
            }
            guard let data else {
                completion(.failure(.emptyData))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print("json: \(json)")
                print("heelooosdfjaksdfjklasjdflk")
                print("data : \(data)")
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
                                           completion: @escaping (Result<[Item],NetworkError>,String?) -> Void )
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

//MARK:
extension NetworkService: PapagoRequestable{
    
//
//    curl "https://openapi.naver.com/v1/papago/n2mt" \
    
//        -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
//        -H "X-Naver-Client-Id: {애플리케이션 등록 시 발급받은 클라이언트 아이디 값}" \
//        -H "X-Naver-Client-Secret: {애플리케이션 등록 시 발급받은 클라이언트 시크릿 값}" \
//        -d "source=ko&target=en&text=만나서 반갑습니다." -v
//
    func translateRequest(_ coffee: Coffee){
        let title = coffee.title
        let description = coffee.description
        let papagoURL = endPoint()
        print(papagoURL)
        var body: [String : String] = [:]
        
        var requestHeader: URLRequest = URLRequest(url: papagoURL)
        requestHeader.setValue("Content-Type", forHTTPHeaderField: HTTPHeaderFields.encoded.string)
        requestHeader.setValue("X-Naver-Client-Id", forHTTPHeaderField: X_Naver_Client_Id)
        requestHeader.setValue("X-Naver-Client-Secret", forHTTPHeaderField: X_Naver_Client_Secret)

        
        body["source"] = "en"
        body["target"] = "kr"
        body["text"] = "\(title) \(description)"
        
        requestHeader.encodeParameters(parameters: body)
        requestHeader.httpMethod = "POST"
        request(url: requestHeader, { result in
            
            switch result {
            case .success(let success):
                print("successs")
            case .failure(let failure):
                print("ffffff: \(failure)")
            }
        })
    }
}
