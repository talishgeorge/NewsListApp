//
//  LogManager.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

private enum LogType: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

internal extension Date {
    func toString() -> String {
        return LogManager.dateFormatter.string(from: self as Date)
    }
}

final class LogManager {
    
    // MARK: - Properties
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    private static var dateFormat = "hh:mm:ss"
    private static var isLoggingEnabled: Bool {
        //        #if DEBUG
        return true
        //        #else
        //        return false
        //        #endif
    }
}

// MARK: - Public Functions
extension LogManager {
    
    class func e( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("LogManager: \(Date().toString()) \(LogType.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
    
    class func i( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("LogManager: \(Date().toString()) \(LogType.i.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
    
    ///   - funcName: Name of the function from where the logging is done
    class func d( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("LogManager: \(Date().toString()) \(LogType.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
    
    class func v( _ object: Any, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("LogManager: \(Date().toString()) \(LogType.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object)")
        }
    }
    
    class func w( _ object: Any?, filename: String = #file, line: Int = #line, funcName: String = #function) {
        if isLoggingEnabled {
            print("LogManager: \(Date().toString()) \(LogType.w.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(funcName) -> \(object!)")
        }
    }
    
    class func s( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        if isLoggingEnabled {
            print("LogManager: \(Date().toString()) \(LogType.s.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    class func req(_ request: RequestModel) {
        guard isLoggingEnabled else { return }
        
        let path: String = request.path
        let headers: String = String(describing: request.headers)
        let httpMethod: String = String(describing: request.method.rawValue)
        var body: String = ""
        var bodyStrings: [String] = []
        for (_, value) in request.body.enumerated() {
            if let valueValue = value.value {
                bodyStrings.append("\(value.key): \(type(of: valueValue))(\(valueValue))")
            } else {
                bodyStrings.append("\(value.key): nil")
            }
        }
        body = bodyStrings.joined(separator: ", ")
        
        var log: String = "[\(ServiceManager.shared.baseURL)\(path)]"
        
        if !request.headers.isEmpty {
            log += "\n\(headers)"
        }
        
        log += "\n[\(httpMethod)]"
        
        if !request.body.isEmpty {
            log += "\n[\(body)]"
        }
        
        print("LogManager: \n--- Request ---\n[\(Date().toString())] \n\(log) \n--- End ---\n")
    }
    
    class func res<T: Decodable>(_ response: ResponseModel<T>) {
        guard isLoggingEnabled else { return }
        
        let path: String? = response.request?.path
        let status: String = response.status
        let message: Int = response.totalResults
        let dataJSON: String? = response.json
        
        var log: String = ""
        
        if let path = path {
            log += "[\(ServiceManager.shared.baseURL)\(path)]\n"
        }
        
        log += "[isSuccess: \(status)]\n[message: \(message)]"
        
        if let json = dataJSON {
            log += "\n[\(json)]"
        }
        
        print("LogManager: \n--- Response ---\n[\(Date().toString())] \n\(log) \n--- End ---\n")
    }
    
    class func err(_ error: ErrorModel) {
        guard isLoggingEnabled else { return }
        
        let errorKey: String? = error.messageKey
        let errorMessage: String? = error.message
        
        var log: String = ""
        
        if let errorKey = errorKey {
            log += "\n[key: \(errorKey)]"
        }
        if let errorMessage = errorMessage {
            log += "\n[message: \(errorMessage)]"
        }
        
        if log.isEmpty { return }
        
        print("LogManager: \n--- Error ---\n[\(Date().toString())] \(log) \n--- End ---\n")
    }
}

// MARK: - Private Functions
private extension LogManager {
    
    class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}
