//
//  ToppingController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct ToppingController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let toppings = routes.grouped("toppings")
        toppings.get(use: index)
        toppings.post(use: create)
        toppings.group(":toppingID") { topping in
            topping.get(use: show)
            topping.put(use: update)
            topping.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [Topping] {
        try await Topping.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> Topping {
        let topping = try req.content.decode(Topping.self)
        try await topping.save(on: req.db)
        return topping
    }
    
    func show(req: Request) async throws -> Topping {
        guard let topping = try await Topping.find(req.parameters.get("toppingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return topping
    }
    
    func update(req: Request) async throws -> Topping {
        let input = try req.content.decode(Topping.self)
        guard let topping = try await Topping.find(req.parameters.get("toppingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        topping.name = input.name
        try await topping.save(on: req.db)
        return topping
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let topping = try await Topping.find(req.parameters.get("toppingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await topping.delete(on: req.db)
        return .noContent
    }
}
