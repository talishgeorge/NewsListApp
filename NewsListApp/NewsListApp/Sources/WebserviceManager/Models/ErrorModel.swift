//
//  ErrorModel.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

final class ErrorModel: Error {
    
    var messageKey: String
    var message: String {
        return ""//messageKey.localized()
    }
    
    init(_ messageKey: String) {
        self.messageKey = messageKey
    }
}

// MARK: - Public Functions

extension ErrorModel {
    
    class func generalError() -> ErrorModel {
        return ErrorModel(ErrorKey.general.rawValue)
    }
}
