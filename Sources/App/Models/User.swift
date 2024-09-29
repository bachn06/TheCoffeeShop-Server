//
//  File.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor
import Fluent
import FluentPostgresDriver

final class User: @unchecked Sendable, Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "avatar_url")
    var avatarURL: String?
    
    @Field(key: "phone")
    var phone: String
    
    @Field(key: "address")
    var address: String
    
    @Children(for: \.$user)
    var orders: [Order]
    
    @OptionalChild(for: \.$user)
    var cart: Cart?
    
    init() {}
    
    init(id: UUID? = nil, avatarURL: String? = nil, phone: String, address: String) {
        self.id = id
        self.avatarURL = avatarURL
        self.phone = phone
        self.address = address
    }
}
