//
//  Message.swift
//  Dronito
//
//  Created by Matheus Andrade on 30/09/21.
//

import Foundation

final class Message: Codable {
    var id: Int?
    var value: Int
    
    init(value: Int){
        self.value = value
    }
}
