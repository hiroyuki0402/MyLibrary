import Foundation

public enum ContentType: String {
    case json = "application/json"
    case formURLEncoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
    case plainText = "text/plain"
    case html = "text/html"
    case xml = "application/xml"
}

public enum HTTPMethod {
    case get([URLQueryItem]?)
    case post(Data?)
    case delete
    case put(Data?)

    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}
