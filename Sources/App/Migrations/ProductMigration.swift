//
//  ProductMigration.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Fluent

struct CreateProduct: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("products")
            .id()
            .field("name", .string, .required)
            .field("image_url", .string)
            .field("price", .string, .required)
            .field("size", .string)
            .field("product_description", .string, .required)
            .field("rating", .double)
            .field("is_favourite", .bool, .required)
            .field("quantity", .int, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("products").delete()
    }
}

struct CreateTopping: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("toppings")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("toppings").delete()
    }
}

struct CreateProductTopping: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("product_toppings")
            .id()
            .field("product_id", .uuid, .required, .references("products", "id"))
            .field("topping_id", .uuid, .required, .references("toppings", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("product_toppings").delete()
    }
}
