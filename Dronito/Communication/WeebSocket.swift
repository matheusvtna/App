//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation

class WeebSocket: NSObject, URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web Socket did connect")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web Socket did disconnect")
    }
}

class WebSocketCommunication: CommunicationProtocol {
    
    //var request: URLRequest
    
    var webSocketTask: URLSessionWebSocketTask
    var isAlive: Bool?

    //    init(serverName: String, port: Int, endpoint: String) {
    //        let resourceString = "http://\(serverName):\(port)/\(endpoint)"
    //        guard let resourceURL = URL(string: resourceString) else { fatalError() }
    //
    //        self.request = URLRequest(url: resourceURL)
    //        self.request.timeoutInterval = 5
    //    }
    
    init(url: URL) {
        let webSocketDelegate = WeebSocket()
        let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
        isAlive = false
        
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask.resume()
        ping()
    }
    
    func ping() {
        webSocketTask.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Web Socket connection is alive")
                self.isAlive = true
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.ping()
                }
            }
        }
    }
    
    func close() {
        let reason = "Closing connection".data(using: .utf8)
        webSocketTask.cancel(with: .goingAway, reason: reason)
        self.isAlive = false
    }
    
    func send(content: Message, completion: @escaping (Result<Message, CommunicationError>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(content)
            guard let json = String(data: jsonData, encoding: String.Encoding.utf16) else { completion(.failure(.encodingError)) ; return}
            
            let message = URLSessionWebSocketTask.Message.string(json)
            webSocketTask.send(message) { error in
                if let _ = error {
                    completion(.failure(.sendingError))
                    return
                }
                
                completion(.success(content))
            }
            
        } catch {
            completion(.failure(.encodingError))
            return
        }
        
    }
    
    func receive(completion: @escaping (Result<Message, CommunicationError>) -> Void) {
        webSocketTask.receive { result in
            switch result {
            case .failure(_):
                completion(.failure(.responseError))
            case .success(let message):
                switch message {
                case .string(let text):
                    guard let value = Int(text) else { completion(.failure(.decodingError)) ; return }
                    let data = Message(value: value)
                    completion(.success(data))
                    
                case .data(let data):
                    do {
                        let json = try JSONEncoder().encode(data)
                        
                        do {
                            let messageData = try JSONDecoder().decode(Message.self, from: json)
                            completion(.success(messageData))
                        } catch {
                            completion(.failure(.decodingError))
                        }
                        
                    } catch {
                        completion(.failure(.encodingError))
                        
                    }
                    
                @unknown default:
                    fatalError()
                }
                
                self.receive(completion: completion)
            }
        }
    }
}
