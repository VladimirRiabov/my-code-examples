

import Foundation

final class Reaction: Codable {
    var id: UUID?
    var reaction: String
    var user: ReactionUser
    var post: ReactionPost
    
    
    init(id: UUID? = nil, reaction: String, userID: UUID, postID: UUID) {
      self.id = id
      self.reaction = reaction
        let user = ReactionUser(id: userID)
        self.user = user
        let post = ReactionPost(id: postID)
        self.post = post
    }
}

final class ReactionUser: Codable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}

final class ReactionPost: Codable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}




