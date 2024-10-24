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
            .field("image", .string, .required)
            .field("price", .double, .required)
            .field("description", .string, .required)
            .field("rating", .double, .required)
            .field("sizes", .array(of: .string), .required)
            .field("toppings", .array(of: .string), .required)
            .field("isFavourite", .bool, .required)
            .field("category_id", .uuid, .references("product_categories", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("products").delete()
    }
}


struct CreateProductCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("product_categories")
            .id()
            .field("image_url", .string, .required)
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("product_categories").delete()
    }
}
