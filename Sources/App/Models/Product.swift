//
//  File.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor
import Fluent
import FluentPostgresDriver

final class Product: @unchecked Sendable, Model, Content {
    static let schema = "products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "image_url")
    var imageURL: String?
    
    @Field(key: "price")
    var price: String
    
    @Field(key: "size")
    var size: Size?
    
    @Field(key: "product_description")
    var productDescription: String
    
    @Field(key: "rating")
    var rating: Double?
    
    @Siblings(through: ProductTopping.self, from: \.$product, to: \.$topping)
    var toppings: [Topping]
    
    @Field(key: "is_favourite")
    var isFavourite: Bool
    
    @Field(key: "quantity")
    var quantity: Int

    init() {}

    init(id: UUID? = nil, name: String, imageURL: String? = nil, price: String, size: Size? = nil, productDescription: String, rating: Double? = nil, isFavourite: Bool = false, quantity: Int) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.size = size
        self.productDescription = productDescription
        self.rating = rating
        self.isFavourite = isFavourite
        self.quantity = quantity
    }
}

final class Topping: @unchecked Sendable, Model, Content {
    static let schema = "toppings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: ProductTopping.self, from: \.$topping, to: \.$product)
    var products: [Product]
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

final class ProductTopping: @unchecked Sendable, Model {
    static let schema = "product_toppings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "product_id")
    var product: Product
    
    @Parent(key: "topping_id")
    var topping: Topping
    
    init() {}
    
    init(id: UUID? = nil, productId: UUID, toppingId: UUID) {
        self.id = id
        self.$product.id = productId
        self.$topping.id = toppingId
    }
}

enum Size: String, Codable {
    case small
    case medium
    case large
}
