//
//  ProductController.swift
//  theCoffeeShop
//
//  Created by BachNguyen on 29/9/24.
//

import Vapor

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("products")
        products.get(use: fetchProducts)
        products.get("favourites", use: fetchFavouriteProducts)
        products.put(":productId", use: updateFavouriteProduct)
    }

    func fetchProducts(req: Request) throws -> EventLoopFuture<[Product]> {
        return Product.query(on: req.db).with(\.$category).all()
    }

    func fetchFavouriteProducts(req: Request) throws -> EventLoopFuture<[Product]> {
        return Product.query(on: req.db)
            .filter(\.$isFavourite, .equal, true)
            .all()
    }

    func updateFavouriteProduct(req: Request) throws -> EventLoopFuture<Product> {
        guard let productId = req.parameters.get("productId", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.find(productId, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { product in
                product.isFavourite.toggle()
                return product.update(on: req.db).map { product }
            }
    }
}
