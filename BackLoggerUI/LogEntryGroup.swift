//
//  LogEntryGroup.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import Foundation
import SwiftDate
import BackLogger

public struct LogEntryGroup {
    public let timestamp:Date
    public private (set) var entries:[LogEntry]
    
    init(entry:LogEntry) {
        self.timestamp = entry.createdAt.startOf(component: .minute)
        self.entries = [entry]
    }
    
    mutating func append(_ entry:LogEntry) {
        entries.append(entry)
    }
    
    mutating func insert(_ entry:LogEntry, at:Int) {
        entries.insert(entry, at: at)
    }
    
    var count:Int {
        return entries.count
    }
}

extension LogEntryGroup: Hashable {
    public var hashValue: Int {
        return timestamp.startOf(component: .minute).hashValue
    }
}

public func ==(left:LogEntryGroup, rigth:LogEntryGroup) -> Bool {
    return left.timestamp.compare(to: rigth.timestamp, granularity: .minute) == .orderedSame
}
