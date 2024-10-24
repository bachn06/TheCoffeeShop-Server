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
    
    app.migrations.add(CreateProductCategory())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateProduct())
    app.migrations.add(CreateCart())
    app.migrations.add(CreateCartItem())
    
    try await app.autoMigrate()
    
    try await app.db.transaction { db in
        return seedDatabase(on: db)
    }.get()
    
    try routes(app)
}

func seedDatabase(on db: Database) -> EventLoopFuture<Void> {
    return ProductCategory.query(on: db).first().flatMap { existingCategory in
        guard existingCategory == nil else {
            return db.eventLoop.future()
        }
        let categories: [ProductCategory] = [
            ProductCategory(id: UUID(), imageUrl: "https://picsum.photos/200/300?random=1", title: "Beverages"),
            ProductCategory(id: UUID(), imageUrl: "https://picsum.photos/200/300?random=2", title: "Lattes"),
            ProductCategory(id: UUID(), imageUrl: "https://picsum.photos/200/300?random=3", title: "Teas"),
            ProductCategory(id: UUID(), imageUrl: "https://picsum.photos/200/300?random=4", title: "Frappuccinos"),
            ProductCategory(id: UUID(), imageUrl: "https://picsum.photos/200/300?random=5", title: "Bakery"),
            ProductCategory(id: UUID(), imageUrl: "https://picsum.photos/200/300?random=6", title: "Espresso")
        ]
        
        let products: [Product] = [
            Product(id: UUID(), name: "Classic Coffee", image: "https://picsum.photos/200/300?random=1", price: 2.99, description: "A classic coffee brewed to perfection.", rating: 4.5, sizes: [.small, .medium, .large], toppings: ["Milk", "Sugar"], isFavourite: true, categoryId: categories[0].id!),
            Product(id: UUID(), name: "Mocha Latte", image: "https://picsum.photos/200/300?random=2", price: 3.99, description: "Rich espresso with steamed milk and chocolate flavor.", rating: 4.8, sizes: [.small, .medium, .large], toppings: ["Chocolate", "Whipped Cream"], isFavourite: false, categoryId: categories[1].id!),
            Product(id: UUID(), name: "Green Tea", image: "https://picsum.photos/200/300?random=3", price: 1.99, description: "Refreshing green tea for a healthy lifestyle.", rating: 4.0, sizes: [.medium, .large], toppings: [], isFavourite: true, categoryId: categories[2].id!),
            Product(id: UUID(), name: "Caramel Frappuccino", image: "https://picsum.photos/200/300?random=4", price: 4.99, description: "Blended coffee drink topped with caramel drizzle.", rating: 4.6, sizes: [.small, .medium], toppings: ["Caramel Drizzle", "Whipped Cream"], isFavourite: false, categoryId: categories[3].id!),
            Product(id: UUID(), name: "Chocolate Chip Cookie", image: "https://picsum.photos/200/300?random=5", price: 1.49, description: "Freshly baked cookie with chocolate chips.", rating: 4.3, sizes: [.small], toppings: [], isFavourite: true, categoryId: categories[4].id!),
            Product(id: UUID(), name: "Espresso Shot", image: "https://picsum.photos/200/300?random=6", price: 1.99, description: "A concentrated shot of coffee.", rating: 4.7, sizes: [.large], toppings: [], isFavourite: false, categoryId: categories[5].id!),
            Product(id: UUID(), name: "Matcha Latte", image: "https://picsum.photos/200/300?random=7", price: 3.99, description: "Smooth latte infused with matcha green tea.", rating: 4.4, sizes: [.small, .medium, .large], toppings: ["Whipped Cream"], isFavourite: true, categoryId: categories[2].id!),
            Product(id: UUID(), name: "Cappuccino", image: "https://picsum.photos/200/300?random=8", price: 3.49, description: "Classic cappuccino with a rich foam layer.", rating: 4.6, sizes: [.small, .medium, .large], toppings: ["Cinnamon"], isFavourite: false, categoryId: categories[0].id!),
            Product(id: UUID(), name: "Blueberry Muffin", image: "https://picsum.photos/200/300?random=9", price: 2.49, description: "Moist muffin loaded with blueberries.", rating: 4.2, sizes: [.small], toppings: [], isFavourite: true, categoryId: categories[4].id!),
            Product(id: UUID(), name: "Iced Americano", image: "https://picsum.photos/200/300?random=10", price: 2.79, description: "Chilled espresso with water over ice.", rating: 4.1, sizes: [.medium, .large], toppings: ["Lemon Slice"], isFavourite: false, categoryId: categories[0].id!)
        ]
        
        let users: [User] = [
            User(id: UUID(), name: "Bach", avatar: "https://avatars.githubusercontent.com/u/64175324", phone: "0123456789", address: "Hung Yen, Hung Yen, Vietnam")
        ]
        
        let carts: [Cart] = [
            Cart(id: UUID(), paymentMethod: .applePay)
        ]
        
        let _ = users.create(on: db)
        let _ = carts.create(on: db)
        
        return categories.create(on: db).flatMap {
            return products.create(on: db)
        }
    }
}
