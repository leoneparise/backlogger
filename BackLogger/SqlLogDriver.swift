//
//  SqlManager.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 05/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit
import SQLite

public class SqlLogDriver: LogDriver {
    // MARK - Public Properties
    public var didLog: DidLogCallback?
    var db:Connection
    
    // MARK: - Data Definition
    private let logs = Table("logs")
    private let id = Expression<Int64>("id")
    private let type = Expression<String>("type")
    private let message = Expression<String>("message")
    private let file = Expression<String>("file")
    private let line = Expression<Int64>("line")
    private let function = Expression<String>("function")
    private let createdAt = Expression<Int64>("created_at")
    private let order = Expression<Int64>("order_seq")
    
    public init?(logFile:String = "logs.sqlite3", inMemory:Bool = false) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let logFileUrl = documentDirectory.appendingPathComponent(logFile)
        
        do {
            if inMemory {
                db = try Connection(.inMemory)
            } else {
                db = try Connection(logFileUrl.absoluteString)
            }            
            try createDatabase()
        } catch {
            print("Backlogger: Can't create database \(error)")
            return nil
        }
    }
    
    private func createDatabase() throws {
        try db.run(logs.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(type)
            t.column(message)
            t.column(file)
            t.column(line)
            t.column(function)
            t.column(createdAt)
            t.column(order)
        })
        
        try db.run(logs.createIndex([type, createdAt, order], ifNotExists: true))
    }
    
    // MARK: - Public Functions
    public func log(entry:LogEntry) {
        do {
            try db.run(logs.insert(
                            type <- entry.type.rawValue,
                            message <- entry.message,
                            file <- entry.file,
                            line <- Int64(entry.line),
                            function <- entry.function,
                            createdAt <- Int64(entry.createdAt.timeIntervalSince1970),
                            order <- entry.order))
        } catch {
            print("Backlogger: Can't insert entry")
            return
        }
        
        didLog?(entry)
    }
    
    public func all(byType typeOrNil:LogType? = nil, offset:Int = 0) -> [LogEntry]? {        
        var query = logs.select([type, message, file, line, function, createdAt, order]) // Select
        if let _type = typeOrNil {
            query = query.filter(type == _type.rawValue)  // If type is present, filter by type
        }
        query = query.order(createdAt.desc, order.desc) // Order by createdAt desc and limit by 50
                     .limit(50, offset: offset)
        
        var entries:[LogEntry] = []
        
        do {
            for log in try db.prepare(query) {
                let entry = LogEntry(
                    createdAt: Date(timeIntervalSince1970: TimeInterval(log[createdAt])),
                    order: log[order],
                    type: LogType(rawValue: log[type])!,
                    file: log[file],
                    line: UInt(log[line]),
                    function: log[function],
                    message: log[message]
                )
                
                entries.append(entry)
            }
        } catch {
            print("Backlogger: Can't fetch entries")
            return nil
        }
        
        return entries
    }
}
