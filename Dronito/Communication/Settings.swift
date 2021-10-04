//
//  UserSettings.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation

enum CommunicationType: Int {
    case HTTP
    case WebSocket
}

class CommunicationSettings {
    
    static let shared: CommunicationSettings = {
        let instance = CommunicationSettings()
        return instance
    }()
    
    var serverName: String {
        didSet {
            self.url = "http://\(serverName):\(port)/\(endpoint)"
        }
    }
    var port: Int {
        didSet {
            self.url = "http://\(serverName):\(port)/\(endpoint)"
        }
    }
    var endpoint: String {
        didSet {
            self.url = "http://\(serverName):\(port)/\(endpoint)"
        }
    }
    var type: CommunicationType     
    var url: String
    
    private init() {
        let defaults = UserDefaults.standard
        
        let typeValue = defaults.object(forKey: "commType") as? Int ?? 0
        self.type = CommunicationType(rawValue: typeValue) ?? .HTTP
        self.serverName = defaults.object(forKey: "commServer") as? String ?? "localhost"
        self.port = defaults.object(forKey: "commPort") as? Int ?? 80
        self.endpoint = defaults.object(forKey: "commEndpoint") as? String ?? ""
        self.url = "http://\(serverName):\(port)/\(endpoint)"
    }
    
    private init(type: CommunicationType, serverName: String, port: Int, endpoint: String) {
        self.type = type
        self.serverName = serverName
        self.port = port
        self.endpoint = endpoint
        self.url = "http://\(serverName):\(port)/\(endpoint)"
    }
    
}
