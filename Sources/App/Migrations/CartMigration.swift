//
//  CartMigration.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Fluent

struct CreateCart: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Cart.schema)
            .id()
            .field("payment_method", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Cart.schema).delete()
    }
}


struct CreateCartItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(CartItem.schema)
            .id()
            .field("product_id", .uuid, .references(Product.schema, "id", onDelete: .cascade))
            .field("size", .string)
            .field("price", .double, .required)
            .field("quantity", .int, .required)
            .field("toppings", .array(of: .string), .required)
            .field("cart_id", .uuid, .required, .references(Cart.schema, "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(CartItem.schema).delete()
    }
}
