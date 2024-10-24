//
//  File.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor
import Fluent

final class CartItem: @unchecked Sendable, Model, Content {
    static let schema = "cart_items"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "product_id")
    var product: Product

    @Field(key: "size")
    var size: String?

    @Field(key: "price")
    var price: Double

    @Field(key: "quantity")
    var quantity: Int

    @Field(key: "toppings")
    var toppings: [String]
    
    @Parent(key: "cart_id")
    var cart: Cart

    init() { }

    init(id: UUID? = nil, productId: UUID, size: String?, price: Double, quantity: Int, toppings: [String], cartId: UUID) {
        self.id = id
        self.$product.id = productId
        self.size = size
        self.price = price
        self.quantity = quantity
        self.toppings = toppings
        self.$cart.id = cartId
    }
}

final class Cart: @unchecked Sendable, Model, Content {
    static let schema = "carts"
    
    @ID(key: .id)
    var id: UUID?

    @Children(for: \.$cart)
    var cartItems: [CartItem]

    @Field(key: "payment_method")
    var paymentMethod: String

    init() { }

    init(id: UUID? = nil, paymentMethod: PaymentMethod) {
        self.id = id
        self.paymentMethod = paymentMethod.rawValue
    }
}

enum PaymentMethod: String, Codable {
    case applePay
    case visaOrMastercard
    case cash
}

enum OrderStatus: String, Codable {
    case confirmed
    case processed
    case delivery
    case completed
}

struct OrderStatusRecord: Codable, Content {
    var id: UUID
    var status: OrderStatus
    var timestamp: Date
}
