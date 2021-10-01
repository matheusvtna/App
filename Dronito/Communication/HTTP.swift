//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 24/09/21.
//

import Foundation

class HTTPCommunication: CommunicationProtocol {
    
    var resourceURL: URL
        
    init(serverName: String, port: Int, endpoint: String) {
        let resourceString = "http://\(serverName):\(port)/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        
        self.resourceURL = resourceURL
    }
    
    init(url: URL){
        self.resourceURL = url
    }
    
    // using protocol -> remove "override" keyword
    func send(content: Message, completion: @escaping (Result<Message, CommunicationError>) -> Void) {
        
        // Create POST request
        do {
            var urlRequest = URLRequest(url: self.resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(content)
            
            // Create Data Task
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                
                // Get response (Status Code 200 = OK)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {completion(.failure(.responseError))
                    return
                }
                
                // Decode message response
                do {
                    let messageData = try JSONDecoder().decode(Message.self, from: jsonData)
                    completion(.success(messageData))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(.encodingError))
        }
        
    }
    
    func receive(completion: @escaping (Result<Message, CommunicationError>) -> Void) {
        // Create GET request
        do {
            var urlRequest = URLRequest(url: self.resourceURL)
            urlRequest.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                
                // Get response (Status Code 200 = OK)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseError))
                    return
                }
                
                // Decode message response
                do {
                    let messageData = try JSONDecoder().decode(Message.self, from: jsonData)
                    completion(.success(messageData))
                } catch {
                    completion(.failure(.decodingError))
                }
                
            }
            task.resume()
        }
    }
    
//    class func getRequest(url: String, completion: @escaping ([String:Any]?, Error? ) -> Void) {
//        guard let URL = URL(string: url) else {
//            completion(nil, nil)
//            return
//        }
//
//        let request = NSMutableURLRequest(url: URL)
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: request as URLRequest) {
//            (data, response, error) in
//            do {
//
//                if let data = data {
//                    //Response came
//                    let response = try JSONSerialization.jsonObject(with: data, options: [])
//                    completion(response as? [String : Any], nil)
//                }
//                else {
//                    //There was not a response
//                    completion(nil, nil)
//                }
//            } catch let error as NSError {
//                // Communication Error between server
//                completion(nil, error)
//            }
//        }
//
//        task.resume()
//    }
    
    
}
