//
//  CartProductController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct CartProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cartProducts = routes.grouped("cart-products")
        cartProducts.get(use: index)
        cartProducts.post(use: create)
        cartProducts.group(":cartProductID") { cartProduct in
            cartProduct.get(use: show)
            cartProduct.put(use: update)
            cartProduct.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [CartProduct] {
        try await CartProduct.query(on: req.db).all()
    }

    func create(req: Request) async throws -> CartProduct {
        let cartProduct = try req.content.decode(CartProduct.self)
        try await cartProduct.save(on: req.db)
        return cartProduct
    }

    func show(req: Request) async throws -> CartProduct {
        guard let cartProduct = try await CartProduct.find(req.parameters.get("cartProductID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return cartProduct
    }

    func update(req: Request) async throws -> CartProduct {
        let input = try req.content.decode(CartProduct.self)
        guard let cartProduct = try await CartProduct.find(req.parameters.get("cartProductID"), on: req.db) else {
            throw Abort(.notFound)
        }
        cartProduct.quantity = input.quantity
        try await cartProduct.save(on: req.db)
        return cartProduct
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let cartProduct = try await CartProduct.find(req.parameters.get("cartProductID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await cartProduct.delete(on: req.db)
        return .noContent
    }
}
