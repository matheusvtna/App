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
    
    var serverName: String
    var port: Int
    var endpoint: String
    var type: CommunicationType
    var url: String
    
    private init() {
        let defaults = UserDefaults.standard

        self.type = defaults.object(forKey: "commType") as? CommunicationType ?? CommunicationType.HTTP
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
