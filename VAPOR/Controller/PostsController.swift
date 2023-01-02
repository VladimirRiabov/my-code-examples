

import Vapor
import Fluent
import SQLKit
import FluentSQL

struct PostsController: RouteCollection {
    let imageFolder = "PostPictures/"
    func boot(routes: Vapor.RoutesBuilder) throws {
        let postsRoutes = routes.grouped("api", "posts")
        postsRoutes.get(use: getAllHandler)
        postsRoutes.get(":postID", use: getHandler)
        postsRoutes.get(":postID", "user", use: getUserHandler)
        postsRoutes.get(":postID", "categories", use: getCategoriesHandler)
        postsRoutes.get("search", use: searchHandler)
        postsRoutes.get("first", use: getFirstHandler)
        postsRoutes.get("sorted", use: getSortedAcronymsHandler)
        postsRoutes.delete(":postID", "categories", ":categoryID", use: removeCategoriesHandler)
        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddlware = User.guardMiddleware()
        let tokenAuthGroup = postsRoutes.grouped(tokenAuthMiddleware, guardAuthMiddlware)
        tokenAuthGroup.on(
            .POST,
            body: .collect(maxSize: "10mb"),
            use: createHandler)
        tokenAuthGroup.delete(":postID", use: deleteHandler)
        tokenAuthGroup.put(":postID", use: updateHandler)
        tokenAuthGroup.post(":postID", "categories", ":categoryID", use: addCategoryHandler)
        tokenAuthGroup.post("cardViewPosts", use: getPostsForCardView)
        tokenAuthGroup.post("favoritePosts", use: getFavoriteUserPosts)
    }
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Post]> {
        Post.query(on: req.db)
            .sort(\.$publicationDate, .descending)
            .all()
    }
    
    func getPostsForCardView(_ req: Request) throws -> EventLoopFuture<[Post]> {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let userIDString = String(userID)
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.internalServerError)
        }
        return sql.raw("SELECT * FROM posts WHERE id NOT IN (SELECT reactions.\"postID\" FROM reactions WHERE reactions.\"userID\" = '\(userIDString)')")
            .all(decoding: Post.self)
    }
    
    func getFavoriteUserPosts(_ req: Request) throws -> EventLoopFuture<[Post]> {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let userIDString = String(userID)
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.internalServerError)
        }
        return sql.raw("SELECT * FROM posts WHERE id IN (SELECT favorites.\"postID\" FROM favorites WHERE favorites.\"userID\" = '\(userIDString)')")
            .all(decoding: Post.self)
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Post> {
        let data = try req.content.decode(CreatePostData.self)
        let user = try req.auth.require(User.self)
        let name = "\(UUID()).jpg"
        
        let postID = UUID()
        let post = try Post(
            id: postID,
            company: data.company,
            title: data.title,
            subtitle: data.subtitle,
            hypothesis: data.hypothesis,
            instrumentName: data.instrumentName,
            publicationDate: data.publicationDate,
            purchasePrice: data.purchasePrice,
            dateOfPurchase: data.dateOfPurchase,
            salePrice: data.salePrice,
            dateOfSale: data.dateOfSale,
            isPublished: data.isPublished,
            isPurchased: data.isPurchased,
            isSaled: data.isSaled,
            userID: user.requireID())
        
        return post.save(on: req.db).map { post }
    }
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<Post> {
        Post.find(req.parameters.get("postID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Post.find(req.parameters.get("postID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { post in
            post.delete(on: req.db).transform(to: .noContent)
        }
    }
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<Post> {
        let updatedPost = try req.content.decode(CreatePostData.self)
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        return Post.find(req.parameters.get("postID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { post in
            post.company = updatedPost.company
            post.title = updatedPost.title
            post.subtitle = updatedPost.subtitle
            post.hypothesis = updatedPost.hypothesis
            post.instrumentName = updatedPost.instrumentName
            post.publicationDate = updatedPost.publicationDate
            post.purchasePrice = updatedPost.purchasePrice
            post.dateOfPurchase = updatedPost.dateOfPurchase
            post.dateOfSale = updatedPost.dateOfSale
            post.salePrice = updatedPost.salePrice
            post.isPublished = updatedPost.isPublished
            post.isPurchased = updatedPost.isPurchased
            post.isSaled = updatedPost.isSaled
            post.$user.id = userID
            return post.save(on: req.db).map { post }
        }
    }
    
    func getUserHandler(_ req: Request) throws -> EventLoopFuture<User.Public> {
        Post.find(req.parameters.get("postID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { post in
            post.$user.get(on: req.db).convertToPublic()
        }
    }
    
    func getCategoriesHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
        Post.find(req.parameters.get("postID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { post in
            post.$categories.get(on: req.db)
        }
    }
    
    func removeCategoriesHandler(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        let postQuery = Post.find(req.parameters.get("postID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        let categoryQuery = Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        return postQuery.and(categoryQuery)
            .flatMap { post, category in
                post
                    .$categories
                    .detach(category, on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    func addCategoryHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let postQuery = Post.find(req.parameters.get("postID"), on: req.db).unwrap(or: Abort(.notFound))
        
        let categoryQuery = Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
        
        return postQuery.and(categoryQuery).flatMap { post, category in
            post.$categories.attach(category, on: req.db).transform(to: .created)
        }
    }
    
    func searchHandler(_ req: Request) throws -> EventLoopFuture<[Post]> {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Post.query(on: req.db).group(.or) { or in
            or.filter(\.$title == searchTerm)
            or.filter(\.$subtitle == searchTerm)
        }.all()
    }
    
    func getFirstHandler(_ req: Request) throws -> EventLoopFuture<Post> {
        Post.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func getSortedAcronymsHandler(_ req: Request) throws -> EventLoopFuture<[Post]> {
        Post.query(on: req.db)
            .sort(\.$title, .ascending)
            .all()
    }
    
}

struct CreatePostData: Content {
    let company: String
    let title: String
    let subtitle: String
    let hypothesis: String
    let instrumentName: String
    let publicationDate: Date
    let purchasePrice: String
    let dateOfPurchase: Date
    let salePrice: String
    let dateOfSale: Date
    let isPublished: Bool
    let isPurchased: Bool
    let isSaled: Bool
}

