//
//  DataManager.swift
//  Dronito
//
//  Created by Matheus Andrade on 06/10/21.
//

import Foundation
import Network

class DataManager {
    
    static let shared: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    @Published var data: String
    
    init() {
        data = ""
    }
}
