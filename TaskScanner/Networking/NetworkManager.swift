//
//  NetworkManager.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Alamofire


// Represents the status of a network operation.
enum NetworkStatus {
    case success
    case failure(NetworkError)
}

// Defines possible network errors based on HTTP status codes or unknown errors.
enum NetworkError: Error {
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unknownError(Error)
    
    // Initializes a NetworkError based on an HTTP status code.
    init(statusCode: Int) {
        switch statusCode {
        case 401:
            self = .unauthorized
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500...599:
            self = .serverError
        default:
            self = .invalidResponse
        }
    }
}

// Maps common HTTP status codes to cases, with a default for unknown codes.
enum HTTPStatusCode: Int {
    case ok = 200
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case unknown = -1
    
    // Initializes an HTTPStatusCode based on an integer status code.
    init(statusCode: Int) {
        self = HTTPStatusCode(rawValue: statusCode) ?? .unknown
    }
}

// Manages network requests related to authentication and task fetching.
class NetworkManager {
    static let shared = NetworkManager()  // Singleton instance.
    
    private let baseUrl = "https://sandboxgeneraldata.blob.core.windows.net/containeraccessv1/"
    private init() {}
    
    // Logs in the user and returns an access token.

    
    // Fetches tasks using the provided access token.
    func fetchTasks() async throws -> [Assignment] {
        let url = "\(baseUrl)Data-Tasks.json"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .responseDecodable(of: [Assignment].self) { response in
                    switch response.result {
                    case .success(let tasks):
                        continuation.resume(returning: tasks)
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            let networkError = NetworkError(statusCode: statusCode)
                            continuation.resume(throwing: networkError)
                        } else {
                            continuation.resume(throwing: NetworkError.unknownError(error))
                        }
                    }
                }
        }
    }
}

// Models for decoding the login response.
struct LoginResponse: Codable {
    let oauth: OAuth
}

struct OAuth: Codable {
    let access_token: String
}
