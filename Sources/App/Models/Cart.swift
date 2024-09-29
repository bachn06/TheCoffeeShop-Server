//
//  File.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor
import Fluent
import FluentPostgresDriver

final class Cart: @unchecked Sendable, Model, Content {
    static let schema = "carts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Siblings(through: CartProduct.self, from: \.$cart, to: \.$product)
    var products: [Product]
    
    @Field(key: "payment_method")
    var paymentMethod: PaymentMethod
    
    @Field(key: "is_checked_out")
    var isCheckedOut: Bool
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID, paymentMethod: PaymentMethod, isCheckedOut: Bool = false) {
        self.id = id
        self.$user.id = userId
        self.paymentMethod = paymentMethod
        self.isCheckedOut = isCheckedOut
    }
}

final class CartProduct: @unchecked Sendable, Model, Content {
    static let schema = "cart_products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "cart_id")
    var cart: Cart
    
    @Parent(key: "product_id")
    var product: Product
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() {}
    
    init(id: UUID? = nil, cartId: UUID, productId: UUID, quantity: Int) {
        self.id = id
        self.$cart.id = cartId
        self.$product.id = productId
        self.quantity = quantity
    }
}


enum PaymentMethod: String, Codable {
    case applePay
    case visaOrMastercard
    case cash
}
