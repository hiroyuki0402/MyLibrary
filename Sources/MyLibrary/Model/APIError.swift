import Foundation

public enum NetworkError: Error {
    case badRequest
    case badURL
    case decodingError(Error)
    case invalidResponse
    case errorResponse(Error)
    case codeValidatoeError(StatusCodeValidatorError)
}

public enum StatusCodeValidatorError: Error {
    case unexpectedStatusCode(statusCode: Int, data: Data?)
}
