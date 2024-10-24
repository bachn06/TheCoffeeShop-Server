//
//  UserController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post("login", use: login)
        users.get(":userId", use: fetchProfile)
        users.put(":userId", use: updateProfile)
    }
    
    func login(req: Request) async throws -> LoginResponse {
        let loginRequest = try req.content.decode(LoginRequest.self)

        guard let user = try await User.query(on: req.db)
            .filter(\.$name, .equal, loginRequest.userName)
            .filter(\.$phone, .equal, loginRequest.phoneNumber)
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }

        return LoginResponse(userId: user.id, accessToken: AccessToken(accessToken: UUID().uuidString, expireIn: 3600))
    }

    func fetchProfile(req: Request) throws -> EventLoopFuture<User> {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        return User.find(userId, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "User not found"))
    }

    func updateProfile(req: Request) throws -> EventLoopFuture<User> {
        let updatedUser = try req.content.decode(User.self)
        
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }
        
        return User.find(userId, on: req.db)
            .unwrap(or: Abort(.notFound, reason: "User not found"))
            .flatMap { user in
                user.name = updatedUser.name
                user.phone = updatedUser.phone
                user.address = updatedUser.address
                
                return user.update(on: req.db).map { user }
            }
    }
}
