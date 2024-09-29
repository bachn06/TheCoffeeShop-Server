//
//  OrderProductController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct OrderProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let orderProducts = routes.grouped("order-products")
        orderProducts.get(use: index)
        orderProducts.post(use: create)
        orderProducts.group(":orderProductID") { orderProduct in
            orderProduct.get(use: show)
            orderProduct.put(use: update)
            orderProduct.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [OrderProduct] {
        try await OrderProduct.query(on: req.db).all()
    }

    func create(req: Request) async throws -> OrderProduct {
        let orderProduct = try req.content.decode(OrderProduct.self)
        try await orderProduct.save(on: req.db)
        return orderProduct
    }

    func show(req: Request) async throws -> OrderProduct {
        guard let orderProduct = try await OrderProduct.find(req.parameters.get("orderProductID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return orderProduct
    }

    func update(req: Request) async throws -> OrderProduct {
        let input = try req.content.decode(OrderProduct.self)
        guard let orderProduct = try await OrderProduct.find(req.parameters.get("orderProductID"), on: req.db) else {
            throw Abort(.notFound)
        }
        orderProduct.quantity = input.quantity
        try await orderProduct.save(on: req.db)
        return orderProduct
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let orderProduct = try await OrderProduct.find(req.parameters.get("orderProductID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await orderProduct.delete(on: req.db)
        return .noContent
    }
}
