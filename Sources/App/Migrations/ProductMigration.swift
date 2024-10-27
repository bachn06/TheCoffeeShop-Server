//
//  ProductMigration.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Fluent

struct CreateProduct: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Product.schema)
            .id()
            .field("name", .string, .required)
            .field("image", .string, .required)
            .field("price", .double, .required)
            .field("description", .string, .required)
            .field("rating", .double, .required)
            .field("sizes", .array(of: .string), .required)
            .field("toppings", .array(of: .string), .required)
            .field("isFavourite", .bool, .required)
            .field("category_id", .uuid, .references(ProductCategory.schema, "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Product.schema).delete()
    }
}

struct CreateProductCategory: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(ProductCategory.schema)
            .id()
            .field("image_url", .string, .required)
            .field("title", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(ProductCategory.schema).delete()
    }
}
