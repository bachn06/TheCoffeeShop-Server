import Vapor

func routes(_ app: Application) throws {
    let userController = UserController()
    try app.register(collection: userController)
    
    let productController = ProductController()
    try app.register(collection: productController)
    
    let cartController = CartController()
    try app.register(collection: cartController)
    
    let cartItemController = CartItemsController()
    try app.register(collection: cartItemController)
}
