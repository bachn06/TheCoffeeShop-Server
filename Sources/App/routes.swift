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
}
