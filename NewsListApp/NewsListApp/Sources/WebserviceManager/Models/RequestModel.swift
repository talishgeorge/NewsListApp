//
//  RequestModel.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class RequestModel: NSObject {
    
    open var path: String {
        return ""
    }
    public var parameters: [String: Any?] {
        return [:]
    }
    public var headers: [String: String] {
        return [:]
    }
    public var method: RequestHTTPMethod {
        return body.isEmpty ? RequestHTTPMethod.get : RequestHTTPMethod.post
    }
    public var body: [String: Any?] {
        return [:]
    }
    
    // (request, response)
    public var isLoggingEnabled: (Bool, Bool) {
        return (true, true)
    }
}

// MARK: - Internal Functions

extension RequestModel {
    
    func urlRequest() -> URLRequest {
        var endpoint: String = ServiceManager.shared.baseURL.appending(path)
        for parameter in parameters {
            if let value = parameter.value as? String {
                endpoint.append("?\(parameter.key)=\(value)")
            }
        }
        var request: URLRequest = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = method.rawValue
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        if method == RequestHTTPMethod.post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch let error {
                LogManager.e("Request body parse error: \(error.localizedDescription)")
            }
        }
        return request
    }
    
    func urlEncoder() -> URLRequest {
        let endpoint: String = ServiceManager.shared.baseURL.appending(path)
        
        let request: URLRequest = URLRequest(url: URL(string: endpoint)!)
        
        return request
    }
}
