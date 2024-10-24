//
//  CartItemsController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 25/10/24.
//

import Vapor

struct CartItemsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cartItems = routes.grouped("cart_items")
        cartItems.put(use: updateCart)
    }
    
    func updateCart(req: Request) throws -> EventLoopFuture<Cart> {
        let updatedItems = try req.content.decode([CartItem].self)
        
        if updatedItems.isEmpty {
            return Cart.query(on: req.db)
                .with(\.$cartItems)
                .first()
                .unwrap(or: Abort(.notFound, reason: "Cart not found"))
                .flatMap { currentCart in
                    let deleteFutures = currentCart.cartItems.map { $0.delete(on: req.db) }
                    
                    return deleteFutures.flatten(on: req.db.eventLoop).flatMap {
                        return Cart.query(on: req.db)
                            .with(\.$cartItems)
                            .first()
                            .unwrap(or: Abort(.notFound, reason: "Cart not found after clearing items"))
                    }
                }
        } else {
            guard let cartId = updatedItems.first?.$cart.id else {
                throw Abort(.badRequest, reason: "No cart ID found in cart items.")
            }
            
            return Cart.query(on: req.db)
                .filter(\.$id, .equal, cartId)
                .with(\.$cartItems)
                .first()
                .unwrap(or: Abort(.notFound, reason: "Cart not found"))
                .flatMap { existingCart in
                    let existingItemIDs = Set(existingCart.cartItems.map { $0.$product.id })
                    var updateFutures: [EventLoopFuture<Void>] = []
                    
                    for newItem in updatedItems {
                        if let existingItem = existingCart.cartItems.first(where: { $0.$product.id == newItem.$product.id }) {
                            existingItem.quantity += newItem.quantity
                            updateFutures.append(existingItem.update(on: req.db).transform(to: ()))
                        } else {
                            updateFutures.append(newItem.save(on: req.db).transform(to: ()))
                        }
                    }
                    
                    let newItemIDs = Set(updatedItems.map { $0.$product.id })
                    for existingItem in existingCart.cartItems {
                        if !newItemIDs.contains(existingItem.$product.id) {
                            updateFutures.append(existingItem.delete(on: req.db).transform(to: ()))
                        }
                    }
                    
                    return updateFutures.flatten(on: req.db.eventLoop).flatMap {
                        return Cart.query(on: req.db)
                            .filter(\.$id, .equal, cartId)
                            .with(\.$cartItems)
                            .first()
                            .unwrap(or: Abort(.notFound, reason: "Cart not found after update"))
                    }
                }
        }
    }
}
