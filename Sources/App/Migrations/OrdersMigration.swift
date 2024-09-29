//
//  OrdersMigration.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Fluent

struct CreateOrder: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("orders")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("orders").delete()
    }
}

struct CreateOrderStatusRecord: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("order_status_records")
            .id()
            .field("status", .string, .required)
            .field("timestamp", .datetime, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("order_status_records").delete()
    }
}

struct CreateOrderProduct: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("order_products")
            .id()
            .field("order_id", .uuid, .required, .references("orders", "id"))
            .field("product_id", .uuid, .required, .references("products", "id"))
            .field("quantity", .int, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("order_products").delete()
    }
}
