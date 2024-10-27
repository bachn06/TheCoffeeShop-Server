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
        carts.get(":userId", use: fetchCart)
        carts.post("order", use: createOrder)
    }

    func fetchCart(req: Request) throws -> EventLoopFuture<Cart> {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }

        return User.query(on: req.db)
            .filter(\.$id, .equal, userId)
            .with(\.$cart)
            .first()
            .unwrap(or: Abort(.notFound, reason: "User not found"))
            .flatMap { user in
                guard let cart = user.cart else {
                    return req.eventLoop.makeFailedFuture(Abort(.notFound, reason: "No cart associated with this user"))
                }
                
                return Cart.query(on: req.db)
                    .filter(\.$id, .equal, cart.id!)
                    .with(\.$cartItems)
                    .first()
                    .unwrap(or: Abort(.notFound, reason: "Cart not found"))
            }
    }
    
    func createOrder(req: Request) throws -> OrderStatusRecord {
        return OrderStatusRecord(id: UUID(), status: .confirmed, timestamp: Date())
    }
}
