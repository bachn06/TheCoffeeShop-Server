//
//  CartMigration.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Fluent

struct CreateCart: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("carts")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("payment_method", .string, .required) // Enum stored as string
            .field("is_checked_out", .bool, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("carts").delete()
    }
}

struct CreateCartProduct: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("cart_products")
            .id()
            .field("cart_id", .uuid, .required, .references("carts", "id"))
            .field("product_id", .uuid, .required, .references("products", "id"))
            .field("quantity", .int, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("cart_products").delete()
    }
}
