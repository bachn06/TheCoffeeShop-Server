//
//  UserMigration.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("avatar", .string, .required)
            .field("phone", .string, .required)
            .field("address", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}
