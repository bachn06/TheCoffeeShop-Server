//
//  File.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor
import Fluent

final class User: @unchecked Sendable, Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "avatar")
    var avatar: String

    @Field(key: "phone")
    var phone: String

    @Field(key: "address")
    var address: String

    init() { }

    init(id: UUID? = nil, name: String, avatar: String, phone: String, address: String) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.phone = phone
        self.address = address
    }
}

struct LoginRequest: Codable {
    var userName: String
    var phoneNumber: String
}

struct LoginResponse: Codable, Content {
    var userId: UUID?
    var accessToken: AccessToken
}

struct AccessToken: Codable, Content {
    var accessToken: String
    var expireIn: Int
}
