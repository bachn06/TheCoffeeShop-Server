//
//  CartController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct CartController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let carts = routes.grouped("carts")
        carts.get(use: fetchCart)
        carts.post("order", use: createOrder)
    }

    func fetchCart(req: Request) throws -> EventLoopFuture<Cart> {
        return Cart.query(on: req.db)
            .with(\.$cartItems)
            .first()
            .unwrap(or: Abort(.notFound, reason: "Cart not found"))
    }
    
    func createOrder(req: Request) throws -> OrderStatusRecord {
        return OrderStatusRecord(id: UUID(), status: .confirmed, timestamp: Date())
    }
}
