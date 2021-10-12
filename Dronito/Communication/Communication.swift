//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation
import Starscream

class Communication: WebSocketDelegate {
    var settings = CommunicationSettings.shared
    var messages = DataManager.shared
    
    var socket: WebSocketCommunication?
    var http: HTTPCommunication?
    var isConnected: Bool = false
    
    static let shared: Communication = {
        let instance = Communication()
        return instance
    }()
    
    init() {}
    
    func connect() {
        switch settings.type {
        case .HTTP:
            isConnected = true
            http = HTTPCommunication(url: URL(string: settings.url)!)    
        case .WebSocket:
            socket = WebSocketCommunication(url: settings.url)
            socket?.connect()
        }
    }
    
    func disconnect() {
        if settings.type == .WebSocket {
            socket?.disconnect()
        }
    }
    
    func send(content: Message) {
        switch settings.type {
        case .HTTP:
            http?.send(content: content, completion: { result in
                switch result {
                case .success(let message):
                    print("The following message has been sent: \(message.value) through HTTP")
                    
                case .failure(let error):
                    print("An error occured on send: \(error)")
                }
            })
            
        case .WebSocket:
            socket?.send(content: content, completion: {_ in })
            break
        }
    }
    
    func receive() {
        switch settings.type {
        case .HTTP:
            http?.receive(completion: { result in
                switch result {
                case .success(let message):
                    print("The following message has been received: \(message.value) through HTTP")
                    
                case .failure(let error):
                    print("An error occured on HTTP receive: \(error)")
                }
            })
            
        case .WebSocket:
            if !isConnected {
                socket?.connect()
            }
            break
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
        
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
}

enum CommunicationError: Error {
    case responseError
    case decodingError
    case encodingError
    case urlError
    case sendingError
}

