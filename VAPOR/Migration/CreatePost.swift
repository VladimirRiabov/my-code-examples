

import Fluent

struct CreatePost: Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("posts")
            .id()
            .field("company", .string, .required)
            .field("title", .string, .required)
            .field("subtitle", .string)
            .field("hypothesis", .string)
            .field("instrumentName", .string)
            .field("publicationDate", .date)
            .field("purchasePrice", .string)
            .field("dateOfPurchase", .date)
            .field("salePrice", .string)
            .field("dateOfSale", .date)
            .field("isPublished", .bool)
            .field("isPurchased", .bool)
            .field("isSaled", .bool)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("posts")
            .delete()
    }
}
