import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db/db.sqlite")), as: .sqlite)
    
    app.migrations.add(CreateCard())
    try await app.autoMigrate()
    // register routes
    try routes(app)
}
