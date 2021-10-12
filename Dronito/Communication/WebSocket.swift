//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation
import Starscream

class WebSocketCommunication {
    var socket: WebSocket!
    var request: URLRequest
    var isConnected = false
    
    init(url: String) {
        request = URLRequest(url: URL(string: url)!) // "ws://10.0.0.175:88/"
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = Communication.shared
    }
    
    func connect() {
        socket = WebSocket(request: request)
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func ping() {
        socket.write(ping: Data("Pingando".utf8))
    }
    
    func send(content: Message, completion: @escaping (Result<Message, CommunicationError>) -> Void) {
        socket.write(string: "Oiiiiiii")
    }
    
}
