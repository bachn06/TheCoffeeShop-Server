import Vapor

func routes(_ app: Application) throws {
    let userController = UserController()
    try app.register(collection: userController)

    let productController = ProductController()
    try app.register(collection: productController)

    let cartController = CartController()
    try app.register(collection: cartController)

    let orderController = OrderController()
    try app.register(collection: orderController)

    let toppingController = ToppingController()
    try app.register(collection: toppingController)

    let orderStatusRecordController = OrderStatusRecordController()
    try app.register(collection: orderStatusRecordController)

    let orderProductController = OrderProductController()
    try app.register(collection: orderProductController)

    let cartProductController = CartProductController()
    try app.register(collection: cartProductController)
    
    app.post("seed") { req async throws -> HTTPStatus in
        try await seedDatabase(req: req)
        return .ok
    }
}

func seedDatabase(req: Request) async throws {
    // Seed Users
    let user1 = User(username: "Bach", avatarURL: "https://picsum.photos/id/0/5000/3333", phone: "1234567890", address: "123 Coffee St")
    let user2 = User(username: "Host", avatarURL: "https://picsum.photos/id/10/2500/1667", phone: "9876543210", address: "456 Espresso Ave")
    
    // Save Users
    try await user1.save(on: req.db)
    try await user2.save(on: req.db)
    
    // Seed Toppings
    let topping1 = Topping(name: "Whipped Cream")
    let topping2 = Topping(name: "Chocolate Syrup")
    let topping3 = Topping(name: "Caramel")
    
    // Save Toppings
    try await topping1.save(on: req.db)
    try await topping2.save(on: req.db)
    try await topping3.save(on: req.db)
    
    // Seed Products
    let product1 = Product(
        name: "Cappuccino",
        imageURL: "https://picsum.photos/id/11/2500/1667",
        price: "4.50",
        size: .medium,
        productDescription: "A classic Italian coffee",
        rating: 4.5,
        isFavourite: false,
        quantity: 10
    )
    
    let product2 = Product(
        name: "Latte",
        imageURL: "https://picsum.photos/id/12/2500/1667",
        price: "5.00",
        size: .large,
        productDescription: "A smooth coffee with steamed milk",
        rating: 4.8,
        isFavourite: true,
        quantity: 15
    )
    
    // Save Products
    try await product1.save(on: req.db)
    try await product2.save(on: req.db)
    
    // Add Toppings to Product
    try await product1.$toppings.attach(topping1, on: req.db)
    try await product1.$toppings.attach(topping2, on: req.db)
    try await product2.$toppings.attach(topping3, on: req.db)
    
    // Seed Cart for user1
    let cart1 = Cart(userId: try user1.requireID(), paymentMethod: .cash, isCheckedOut: false)
    
    // Save Cart
    try await cart1.save(on: req.db)
    
    // Add Products to Cart
    let cartProduct1 = CartProduct(cartId: try cart1.requireID(), productId: try product1.requireID(), quantity: 2)
    let cartProduct2 = CartProduct(cartId: try cart1.requireID(), productId: try product2.requireID(), quantity: 1)
    
    // Save Cart Products
    try await cartProduct1.save(on: req.db)
    try await cartProduct2.save(on: req.db)
    
    // Seed Order for user1
    let order1 = Order()
    order1.$user.id = try user1.requireID()
    
    // Save Order
    try await order1.save(on: req.db)
    
    let statusRecord = OrderStatusRecord(orderId: try order1.requireID(), status: .confirmed, timestamp: Date())
    try await statusRecord.save(on: req.db)
    
    // Add Products to Order
    let orderProduct1 = OrderProduct(orderId: try order1.requireID(), productId: try product1.requireID(), quantity: 1)
    let orderProduct2 = OrderProduct(orderId: try order1.requireID(), productId: try product2.requireID(), quantity: 3)
    
    // Save Order Products
    try await orderProduct1.save(on: req.db)
    try await orderProduct2.save(on: req.db)

    req.logger.info("Database seeded successfully")
}
