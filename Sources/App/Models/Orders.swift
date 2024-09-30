//
//  File.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor
import Fluent
import FluentPostgresDriver

final class Order: @unchecked Sendable, Model, Content {
    static let schema = "orders"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Children(for: \.$order)
    var statusRecords: [OrderStatusRecord]
    
    @Children(for: \.$order)
    var orderProducts: [OrderProduct]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil) {
        self.id = id
    }
}

final class OrderStatusRecord: @unchecked Sendable, Model, Content {
    static let schema = "order_status_records"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "order_id")
    var order: Order
    
    @Field(key: "status")
    var status: OrderStatus
    
    @Field(key: "timestamp")
    var timestamp: Date

    init() {}

    init(id: UUID? = nil, orderId: UUID, status: OrderStatus, timestamp: Date) {
        self.id = id
        self.$order.id = orderId
        self.status = status
        self.timestamp = timestamp
    }
}


final class OrderProduct: @unchecked Sendable, Model, Content {
    static let schema = "order_products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "order_id")
    var order: Order
    
    @Parent(key: "product_id")
    var product: Product
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() {}
    
    init(id: UUID? = nil, orderId: UUID, productId: UUID, quantity: Int) {
        self.id = id
        self.$order.id = orderId
        self.$product.id = productId
        self.quantity = quantity
    }
}

enum OrderStatus: String, Codable {
    case confirmed
    case processed
    case delivery
    case completed
}
