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
        carts.get(use: index)
        carts.post(use: create)
        carts.group(":cartID") { cart in
            cart.get(use: show)
            cart.put(use: update)
            cart.delete(use: delete)
            cart.post("checkout", use: checkout)
            cart.post("addProduct", use: addProduct)
        }
    }

    func index(req: Request) async throws -> [Cart] {
        try await Cart.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Cart {
        let cart = try req.content.decode(Cart.self)
        try await cart.save(on: req.db)
        return cart
    }

    func show(req: Request) async throws -> Cart {
        guard let cart = try await Cart.find(req.parameters.get("cartID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return cart
    }

    func update(req: Request) async throws -> Cart {
        let input = try req.content.decode(Cart.self)
        guard let cart = try await Cart.find(req.parameters.get("cartID"), on: req.db) else {
            throw Abort(.notFound)
        }
        cart.paymentMethod = input.paymentMethod
        try await cart.save(on: req.db)
        return cart
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let cart = try await Cart.find(req.parameters.get("cartID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await cart.delete(on: req.db)
        return .noContent
    }

    func checkout(req: Request) async throws -> HTTPStatus {
        guard let cart = try await Cart.find(req.parameters.get("cartID"), on: req.db) else {
            throw Abort(.notFound)
        }
        cart.isCheckedOut = true
        try await cart.save(on: req.db)
        return .ok
    }

    func addProduct(req: Request) async throws -> HTTPStatus {
        let data = try req.content.decode(CartProduct.self)
        try await data.save(on: req.db)
        return .ok
    }
}
