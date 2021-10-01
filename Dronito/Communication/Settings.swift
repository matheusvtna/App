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
    static var shared = CommunicationSettings()
    
    let defaults = UserDefaults.standard
    
    var serverName: String {
        get {
            return self.serverName
        }
        
        set(newServer){
            self.serverName = newServer
        }
    }
    
    var port: Int {
        get {
            return self.port
        }
        
        set(newPort){
            self.port = newPort
        }
    }
    
    var endpoint: String {
        get {
            return self.endpoint
        }
        
        set(newEndpoint){
            self.endpoint = newEndpoint
        }
    }
    
    var type: CommunicationType {
        get {
            return self.type
        }
        set(newType) {
            self.type = newType
        }
    }
    
    var url: String {
        get {
            return self.url
        }
        set(newURL) {
            self.url = newURL
        }
    }
    
    init() {
        self.type = defaults.object(forKey: "commType") as? CommunicationType ?? CommunicationType.HTTP
        self.serverName = defaults.object(forKey: "commServer") as? String ?? "localhost"
        self.port = defaults.object(forKey: "commPort") as? Int ?? 80
        self.endpoint = defaults.object(forKey: "commEndpoint") as? String ?? ""
        self.url = getResourceURL()
    }
    
    init(type: CommunicationType, serverName: String, port: Int, endpoint: String) {
        self.type = type
        self.serverName = serverName
        self.port = port
        self.endpoint = endpoint
        self.url = getResourceURL()
    }
    
    func getResourceURL() -> String {
        return "http://\(serverName):\(port)/\(endpoint)"
    }
    
}
