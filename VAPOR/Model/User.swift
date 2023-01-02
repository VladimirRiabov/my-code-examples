

import Fluent
import Vapor

final class User: Model {
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String

    @Field(key: "username")
    var username: String
    
    @Children(for: \.$user)
    var posts: [Post]
    
    @Field(key: "password")
    var password: String
    
    @Siblings(through: ReactionPostUserPivot.self, from: \.$user, to: \.$reaction)
    var reactions: [Reaction]
    
    @Siblings(through: FavoritePostUserPivot.self, from: \.$user, to: \.$favorite)
    var favoritePosts: [Favorite]
    
    
    
    init() { }
    
    init(id: UUID? = nil, name: String, username: String, password: String) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
    }

    static let schema: String = "users"
    
    struct Public: Content {
        var id: UUID?
        var name: String
        var username: String
    }
    
}

extension User: Content {}

extension User {
    func convertToPublic() -> User.Public {
        User.Public(id: self.id, name: self.name, username: self.username)
    }
}

extension EventLoopFuture where Value: User {
    func convertToPublic() -> EventLoopFuture<User.Public> {
        self.map { user in
            user.convertToPublic()
        }
    }
}

extension Collection where Element: User {
    func convertToPublic() -> [User.Public] {
        self.map {
            $0.convertToPublic()
        }
    }
}

extension EventLoopFuture where Value == Array<User> {
    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        self.map { $0.convertToPublic()}
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey: KeyPath<User, Field<String>> {
        \User.$username
    }
    
    static var passwordHashKey: KeyPath<User, Field<String>> {
        \User.$password
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}


extension User: ModelCredentialsAuthenticatable {
    
}

extension User: ModelSessionAuthenticatable {
    
}

