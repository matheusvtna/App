//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation

class WebSocketCommunication: CommunicationProtocol {
    
    var request: URLRequest

    init(serverName: String, port: Int, endpoint: String) {
        let resourceString = "http://\(serverName):\(port)/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }

        self.request = URLRequest(url: resourceURL)
        self.request.timeoutInterval = 5
    }

    init(url: URL) {
        self.request = URLRequest(url: url)
    }
    
    func send(content: Message, completion: @escaping (Result<Message, CommunicationError>) -> Void) {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: self.request)
        webSocketTask.resume()
        
        var data = Data()
        
        do {
            data = try JSONEncoder().encode(content)
        }
        catch {
            completion(.failure(.encodingError))
        }

        let message = URLSessionWebSocketTask.Message.data(data)
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
        
    }
    
    func receive(completion: @escaping (Result<Message, CommunicationError>) -> Void) {
        print("oi")
    }
    
    
}
