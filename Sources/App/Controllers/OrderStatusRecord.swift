//
//  OrderStatusRecord.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct OrderStatusRecordController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let records = routes.grouped("order-status-records")
        records.get(use: index)
        records.post(use: create)
        records.group(":recordID") { record in
            record.get(use: show)
            record.put(use: update)
            record.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [OrderStatusRecord] {
        try await OrderStatusRecord.query(on: req.db).all()
    }

    func create(req: Request) async throws -> OrderStatusRecord {
        let record = try req.content.decode(OrderStatusRecord.self)
        try await record.save(on: req.db)
        return record
    }

    func show(req: Request) async throws -> OrderStatusRecord {
        guard let record = try await OrderStatusRecord.find(req.parameters.get("recordID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return record
    }

    func update(req: Request) async throws -> OrderStatusRecord {
        let input = try req.content.decode(OrderStatusRecord.self)
        guard let record = try await OrderStatusRecord.find(req.parameters.get("recordID"), on: req.db) else {
            throw Abort(.notFound)
        }
        record.status = input.status
        record.timestamp = input.timestamp
        try await record.save(on: req.db)
        return record
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let record = try await OrderStatusRecord.find(req.parameters.get("recordID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await record.delete(on: req.db)
        return .noContent
    }
}
