//
//  ResponseHandler+Extension.swift
//  CleanArchitecture
//
//  Created by richa on 16/12/20.
//  Copyright © 2020 harsivo. All rights reserved.
//

import Foundation
// MARK: Response Handler - parse default

struct ServiceError: Error,Codable {
    let httpStatus: Int
    let message: String
}

extension ResponseHandler {
    func defaultParseResponse<T: Codable>(data: Data, response: HTTPURLResponse) throws -> T {
        let jsonDecoder = JSONDecoder()
        
       /*do {
            let body = try jsonDecoder.decode(T.self, from: data)
            
            if response.statusCode == 200 {
                return body
            } else {
                throw ServiceError(httpStatus: response.statusCode, message: "Unknown Error")
            }
        } catch  {
            throw ServiceError(httpStatus: response.statusCode, message: error.localizedDescription)
        }*/
        
        do {
            let data = try jsonDecoder.decode(T.self, from: data)
            print("Parsing Success\(data)")
            
            if response.statusCode == 200 {
                return data
            } else {
                throw ServiceError(httpStatus: response.statusCode, message: "Unknown Error")
            }
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            
            throw ServiceError(httpStatus: response.statusCode, message: "context.localizedDescription")
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
            throw ServiceError(httpStatus: response.statusCode, message: "error.localizedDescription")
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            
            throw ServiceError(httpStatus: response.statusCode, message: "error.localizedDescription")
        }
        catch {
            print("Parse error \(error.localizedDescription)")
            throw ServiceError(httpStatus: response.statusCode, message: error.localizedDescription)
        }
    }
}


