#  All api Path

User Endpoints
Create User

URL: POST /users
Description: Create a new user.
Get User

URL: GET /users/:id
Description: Retrieve a user by ID.
Update User

URL: PUT /users/:id
Description: Update a user by ID.
Delete User

URL: DELETE /users/:id
Description: Delete a user by ID.
Get User Orders

URL: GET /users/:id/orders
Description: Retrieve all orders for a specific user.
Product Endpoints
Create Product

URL: POST /products
Description: Create a new product.
Get Product

URL: GET /products/:id
Description: Retrieve a product by ID.
Update Product

URL: PUT /products/:id
Description: Update a product by ID.
Delete Product

URL: DELETE /products/:id
Description: Delete a product by ID.
Get All Products

URL: GET /products
Description: Retrieve all products.
Order Endpoints
Create Order

URL: POST /orders
Description: Create a new order.
Get Order

URL: GET /orders/:id
Description: Retrieve an order by ID.
Update Order

URL: PUT /orders/:id
Description: Update an order by ID.
Delete Order

URL: DELETE /orders/:id
Description: Delete an order by ID.
Get User Orders

URL: GET /users/:userId/orders
Description: Retrieve all orders for a specific user.
Cart Endpoints
Create Cart

URL: POST /carts
Description: Create a new cart.
Get Cart

URL: GET /carts/:id
Description: Retrieve a cart by ID.
Update Cart

URL: PUT /carts/:id
Description: Update a cart by ID.
Delete Cart

URL: DELETE /carts/:id
Description: Delete a cart by ID.
Get Cart Products

URL: GET /carts/:id/products
Description: Retrieve all products in a cart.
Topping Endpoints
Create Topping

URL: POST /toppings
Description: Create a new topping.
Get Topping

URL: GET /toppings/:id
Description: Retrieve a topping by ID.
Update Topping

URL: PUT /toppings/:id
Description: Update a topping by ID.
Delete Topping

URL: DELETE /toppings/:id
Description: Delete a topping by ID.
Order Status Record Endpoints
Get Order Status Records
URL: GET /orders/:orderId/status
Description: Retrieve all status records for a specific order.
Cart Product Endpoints
Add Product to Cart

URL: POST /carts/:cartId/products
Description: Add a product to the cart.
Remove Product from Cart

URL: DELETE /carts/:cartId/products/:productId
Description: Remove a product from the cart.
