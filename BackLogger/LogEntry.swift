//
//  LogEntry.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 05/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import Foundation

// MARK: - Global Counter
fileprivate var counter: Int64 = 0
fileprivate func next() -> Int64 {
    counter = counter + 1
    return counter
}

// MARK: - Model
public enum LogType:String {
    case info = "info", debug = "debug", warn = "warn", error = "error"
}

public struct LogEntry {
    public let type: LogType
    public let message: String
    public let file: String
    public let line: UInt
    public let function: String
    public let createdAt: Date
    public let order:Int64
    
    public init(createdAt: Date, order:Int64?, type:LogType, file:String, line:UInt, function:String, message:String) {
        self.type = type
        self.message = message
        self.file = file
        self.line = line
        self.function = function
        self.createdAt = createdAt
        self.order = order != nil ? order! : next()
    }
    
    func toJson() -> [AnyHashable : Any] {
        return [
            "type": self.type,
            "message": self.message,
            "file": self.file,
            "line": self.line,            
            "function": self.function,
            "createdAt": self.createdAt
        ]
    }
}

// MARK: - Equatable
extension LogEntry: Equatable { }
public func == (left:LogEntry, right:LogEntry) -> Bool {
    return left.createdAt == right.createdAt && left.order == right.order
}

// MARK: - Comparable
extension LogEntry: Comparable { }
public func < (left:LogEntry, right:LogEntry) -> Bool {
    return (left.createdAt < right.createdAt) ||
           (left.createdAt == right.createdAt && left.order < right.order)
    
}

public func <= (left:LogEntry, right:LogEntry) -> Bool {
    return (left.createdAt < right.createdAt) ||
           (left.createdAt == right.createdAt && left.order <= right.order)
}

public func > (left:LogEntry, right:LogEntry) -> Bool {
    return (left.createdAt > right.createdAt) ||
           (left.createdAt == right.createdAt && left.order > right.order)
    
}

public func >= (left:LogEntry, right:LogEntry) -> Bool {
    return (left.createdAt > right.createdAt) ||
           (left.createdAt == right.createdAt && left.order >= right.order)
    
}
