//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation

class WebSocketCommunication: CommunicationProtocol {
    
    let settings = CommunicationSettings.shared
    var webSocketTask: URLSessionWebSocketTask
    private var pingTimer: Timer?
    var isAlive: Bool?
    
    init() {
        let url = URL(string: settings.url)
        webSocketTask = URLSession.shared.webSocketTask(with: url!)
        isAlive = false
    }
    
    func ping() {
        webSocketTask.sendPing { error in
            if let error = error {
                print("Error when sending PING \(error)")
            } else {
                print("Web Socket connection is alive")
                self.isAlive = true
                self.pingTimer = Timer.scheduledTimer(withTimeInterval: 25.0, repeats: true) { time in
                    self.ping()
                }
            }
        }
    }
    
    func connect() {
        var url = URL(string: settings.url)
        
        // MUDA ESSA URL PARA O TEU IP:PORT/ENDPOINT
        url = URL(string: "wss://echo.websocket.org")
        webSocketTask = URLSession.shared.webSocketTask(with: url!)
        webSocketTask.resume()
        ping()
    }
    
    func disconnect() {
        let reason = "Closing connection".data(using: .utf8)
        webSocketTask.cancel(with: .goingAway, reason: reason)
        isAlive = false
        pingTimer?.invalidate()
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
