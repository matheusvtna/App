//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation

class Communication {

    var settings = CommunicationSettings.shared
    var messages = DataManager.shared
    var socket: WebSocketCommunication?
    var http: HTTPCommunication?
    
    static let shared: Communication = {
        let instance = Communication()
        return instance
    }()
    
    init() {}
    
    func connect() {
        if settings.type == .WebSocket {
            socket?.connect()
        }
    }
    
    func disconnect() {
        if settings.type == .HTTP {
            socket?.disconnect()
        }
    }
    
    func send(content: Message) {
        guard let url = URL(string: settings.url) else {
            print("Invalid URL from: \(settings.url)")
            return
        }
        
        switch self.settings.type {
        case .HTTP:
            socket?.disconnect()
            http?.resourceURL = url
            http?.send(content: content, completion: { result in
                switch result {
                case .success(let message):
                    print("The following message has been sent: \(message.value) through HTTP")
                    
                case .failure(let error):
                    print("An error occured on send: \(error)")
                }
            })

        case .WebSocket:
            socket?.send(content: content, completion: { result in
                switch result{
                case .success(let message):
                    print("The following message has been sent: \(message.value) through WebSocket")

                case .failure(let error):
                    print("An error occured on send: \(error)")
                }                
            })
        }
    }
    
    func receive() {
        guard let url = URL(string: settings.url) else {
            print("Invalid URL from: \(settings.url)")
            return
        }
        
        switch self.settings.type {
        case .HTTP:
            let http = HTTPCommunication(url: url)
            http.receive(completion: { result in
                switch result {
                case .success(let message):
                    print("The following message has been received: \(message.value) through HTTP")
                    
                case .failure(let error):
                    print("An error occured on HTTP receive: \(error)")
                }
            })
            
        case .WebSocket:
            socket?.receive(completion: { result in
                switch result {
                case .success(let message):
                    print("The following message has been received: \(message.value) through WebSocket")
                    
                case .failure(let error):
                    print("An error occured on WebSocket receive: \(error)")
                }})
        }
    }
    
    func isAlive() -> Bool {
        switch self.settings.type {
        case .HTTP:
            if let _ = NSURL(string: settings.url) {
                return true
            }
            return false
        case .WebSocket:
            return socket?.isAlive ?? false
        }
    }
}

protocol CommunicationProtocol {
    var isAlive: Bool? { get }
    func send(content: Message, completion: @escaping(Result<Message, CommunicationError>) -> Void);
    func receive(completion: @escaping(Result<Message, CommunicationError>) -> Void);
}

enum CommunicationError: Error {
    case responseError
    case decodingError
    case encodingError
    case urlError
    case sendingError
}

