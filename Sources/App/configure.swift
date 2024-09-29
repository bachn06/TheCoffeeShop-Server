import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    app.databases.use(.postgres(
        hostname: "localhost",
        port: 5432,
        username: "bachnguyen",
        password: "",
        database: "TheCoffeeShopDB"
    ), as: .psql)
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateProduct())
    app.migrations.add(CreateTopping())
    app.migrations.add(CreateProductTopping())
    app.migrations.add(CreateOrder())
    app.migrations.add(CreateOrderStatusRecord())
    app.migrations.add(CreateOrderProduct())
    app.migrations.add(CreateCart())
    app.migrations.add(CreateCartProduct())
    
    try routes(app)
}
