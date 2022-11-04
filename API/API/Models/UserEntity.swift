//
//  User.swift
//  API
//
//  Created by Murat ŞENOL on 4.11.2022.
//

import Foundation

public struct UserEntity: Codable {
    public let id: String?
    public let username: String?
    public let email: String?
    
    public init(id: String, username: String?, email: String?) {
        self.id = id
        self.username = username
        self.email = email
    }
    
    enum CodingKeys: String, CodingKey {
            case id
            case username
            case email
    }
    
}
