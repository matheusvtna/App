//
//  Communication.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation

class Communication {
    var settings: CommunicationSettings
    
    init(settings: CommunicationSettings) {
        self.settings = settings
    }
    
    func send(content: Message) {
        switch self.settings.type {
        case .HTTP:
            guard let url = URL(string: settings.url) else {
                print("Invalid URL from: \(settings.url)")
                return
            }
            let http = HTTPCommunication(url: url)
            http.send(content: content, completion: { result in
                switch result {
                case .success(let message):
                    print("The following message has been sent: \(message.value)")
                    
                case .failure(let error):
                    print("An error occured \(error)")
                }
                
            })
            break
        case .WebSocket:
            // socket
            break
        }
    }
    
    func receive() {
        switch self.settings.type {
        case .HTTP:
            guard let url = URL(string: settings.url) else {
                print("Invalid URL from: \(settings.url)")
                return
            }
            let http = HTTPCommunication(url: url)
            http.receive(completion: { result in
                switch result {
                case .success(let message):
                    print("The following message has been sent: \(message.value)")
                    
                case .failure(let error):
                    print("An error occured \(error)")
                }
                
            })
            break
        case .WebSocket:
            // socket
            break
        }
    }
}

protocol CommunicationProtocol {
    func send(content: Message, completion: @escaping(Result<Message, CommunicationError>) -> Void);
    func receive(completion: @escaping(Result<Message, CommunicationError>) -> Void);
}

enum CommunicationError: Error {
    case responseError
    case decodingError
    case encodingError
    case urlError
    case protocolError
}

