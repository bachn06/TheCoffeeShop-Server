//
//  File.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor
import Fluent

final class Product: @unchecked Sendable, Model, Content {
    static let schema = "products"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "image")
    var image: String

    @Field(key: "price")
    var price: Double

    @Field(key: "description")
    var productDescription: String

    @Field(key: "rating")
    var rating: Double

    @Field(key: "sizes")
    var sizes: [Size]

    @Field(key: "toppings")
    var toppings: [String]

    @Field(key: "isFavourite")
    var isFavourite: Bool

    @Parent(key: "category_id")
    var category: ProductCategory

    init() { }

    init(id: UUID? = nil, name: String, image: String, price: Double, description: String, rating: Double, sizes: [Size], toppings: [String], isFavourite: Bool, categoryId: UUID) {
        self.id = id
        self.name = name
        self.image = image
        self.price = price
        self.productDescription = description
        self.rating = rating
        self.sizes = sizes
        self.toppings = toppings
        self.isFavourite = isFavourite
        self.$category.id = categoryId
    }
}

final class ProductCategory: @unchecked Sendable, Model, Content {
    static let schema = "product_categories"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "image_url")
    var imageUrl: String

    @Field(key: "title")
    var title: String

    init() { }

    init(id: UUID? = nil, imageUrl: String, title: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.title = title
    }
}

enum Size: String, Codable {
    case small
    case medium
    case large
}
