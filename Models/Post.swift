


import Foundation

final class Post: Codable, Equatable {
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: UUID?
    var company: String
    var title: String
    var subtitle: String
    var hypothesis: String
    var instrumentName: String
    var publicationDate: String
    var purchasePrice: String
    var dateOfPurchase: String
    var salePrice: String
    var dateOfSale: String
    var isPublished: Bool
    var isPurchased: Bool
    var isSaled: Bool
    var user: PostUser
    
    init(id: UUID? = nil, company: String, title: String, subtitle: String, hypothesis: String, instrumentName: String, publicationDate: String, purchasePrice: String, dateOfPurchase: String, salePrice: String, dateOfSale: String, isPublished: Bool, isPurchased: Bool, isSaled: Bool, userID: UUID, reactions: [Reaction]) {
        self.id = id
        self.company = company
        self.title = title
        self.subtitle = subtitle
        self.hypothesis = hypothesis
        self.instrumentName = instrumentName
        self.publicationDate = publicationDate
        self.purchasePrice = purchasePrice
        self.dateOfPurchase = dateOfPurchase
        self.dateOfSale = dateOfSale
        self.salePrice = salePrice
        self.isPublished = isPublished
        self.isPurchased = isPurchased
        self.isSaled = isSaled
        let user = PostUser(id: userID)
        self.user = user
        
    }
}

final class PostUser: Codable {
    var id: UUID
    
    init(id: UUID) {
        self.id = id
    }
}



