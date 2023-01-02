


import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol APIRequest {
    associatedtype Response
    
    var method: HTTPMethod { get }
    var path: String { get }
    var contentType: String { get }
    var additionalHeaders: [String: String] { get }
    var pathComponets: String? { get }
    var body: Data? { get }
    
    func handle(response: Data) throws -> Response
}
