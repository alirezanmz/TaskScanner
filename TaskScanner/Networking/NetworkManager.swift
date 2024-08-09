//
//  NetworkManager.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseUrl = "https://api.baubuddy.de/"
    
    private init() {}
    
    func login() async throws -> String {
        let url = "\(baseUrl)index.php/login"
        let parameters: [String: Any] = [
            "username": "365",
            "password": "1"
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    continuation.resume(returning: loginResponse.oauth.access_token)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchTasks(token: String) async throws -> [Assignment] {
        let url = "\(baseUrl)dev/index.php/v1/tasks/select"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers).responseDecodable(of: [Assignment].self) { response in
                switch response.result {
                case .success(let tasks):
                    continuation.resume(returning: tasks)
                case .failure(let error):
                    
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

struct LoginResponse: Codable {
    let oauth: OAuth
}

struct OAuth: Codable {
    let access_token: String
}
