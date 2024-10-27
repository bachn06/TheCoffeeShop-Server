## Requirements
- [Vapor](https://vapor.codes/docs/4.0/getting-started/installation)
- [PostgreSQL](https://www.postgresql.org/download/)

## Getting Started

### 1. Running Postgres.app and initilize server, make sure Postgres always running

### 2. Use ``psql`` to create the database
Open terminal and run the follow:
1. export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
2. psql -U postgres
3. CREATE DATABASE "TheCoffeeShopDB";
4. Open configure.swift, replace username as your root name on postgres (run lsof -i :5432 to see which user running postgres)
5. Build project
