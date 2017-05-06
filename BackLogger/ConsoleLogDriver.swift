//
//  ConsoleLogDriver.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import Foundation

fileprivate func defaultDateFormatter() -> DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
    return df
}

public class ConsoleLogDriver: LogDriver {
    public var didLog: DidLogCallback?
    public var logString:(LogEntry) -> String = { entry in
        let dateFormatter:DateFormatter = defaultDateFormatter()
        return "\(dateFormatter.string(from: entry.createdAt)) [\(entry.type)] \(entry.file):\(entry.line) \(entry.message)"
    }
    
    public init?() {
        
    }
    
    public func log(entry: LogEntry) {
        print(logString(entry))
        didLog?(entry)
    }
    
    public func all(byType typeOrNil: LogType?, offset: Int) -> [LogEntry]? {
        return nil
    }
}
