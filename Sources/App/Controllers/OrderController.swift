//
//  OrderController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct OrderController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let orders = routes.grouped("orders")
        orders.get(use: index)
        orders.post(use: create)
        orders.group(":orderID") { order in
            order.get(use: show)
            order.put(use: update)
            order.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Order] {
        try await Order.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Order {
        let order = try req.content.decode(Order.self)
        try await order.save(on: req.db)
        return order
    }

    func show(req: Request) async throws -> Order {
        guard let order = try await Order.find(req.parameters.get("orderID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return order
    }

    func update(req: Request) async throws -> Order {
        let input = try req.content.decode(Order.self)
        guard let order = try await Order.find(req.parameters.get("orderID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await order.save(on: req.db)
        return order
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let order = try await Order.find(req.parameters.get("orderID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await order.delete(on: req.db)
        return .noContent
    }
}
