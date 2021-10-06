//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 24/09/21.
//

import Foundation

class HTTPCommunication: CommunicationProtocol {
    
    var resourceURL: URL
    var isAlive: Bool?
    
    init(serverName: String, port: Int, endpoint: String) {
        let resourceString = "http://\(serverName):\(port)/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        
        self.resourceURL = resourceURL
    }
    
    init(url: URL){
        self.resourceURL = url
    }
    
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
}
