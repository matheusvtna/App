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
            self.url = getURL()
        }
    }
    var port: Int {
        didSet {
            self.url = getURL()
        }
    }
    var endpoint: String {
        didSet {
            self.url = getURL()
        }
    }
    var type: CommunicationType    {
        didSet {
            self.url = getURL()
        }
    }
    var url: String
    
    private init() {
        let defaults = UserDefaults.standard
        
        let typeValue = defaults.object(forKey: "commType") as? Int ?? 0
        self.type = CommunicationType(rawValue: typeValue) ?? .HTTP
        self.serverName = defaults.object(forKey: "commServer") as? String ?? "localhost"
        self.port = defaults.object(forKey: "commPort") as? Int ?? 80
        self.endpoint = defaults.object(forKey: "commEndpoint") as? String ?? ""
        self.url = ""
        self.url = getURL()
    }
    
    private init(type: CommunicationType, serverName: String, port: Int, endpoint: String) {
        self.type = type
        self.serverName = serverName
        self.port = port
        self.endpoint = endpoint
        self.url = ""
        self.url = getURL()
    }

    func getURL() -> String {
        let prefix = self.type == .HTTP ? "http" : "ws"
        return "\(prefix)://\(serverName):\(port)/\(endpoint)"
    }

}

