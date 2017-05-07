//
//  LogEntryDatasource.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit
import SwiftDate
import BackLogger

public struct Change {
    public let indexPath:IndexPath
    public let createSection:Bool
    
    public init(indexPath:IndexPath, createSection:Bool) {
        self.indexPath = indexPath
        self.createSection = createSection
    }
}

public class TimelineDatasource:NSObject {
    public static let cellIdentifier = "TimelineCell"
    
    fileprivate var groups: [LogEntryGroup] = []
    public private(set) var offset:Int = 0
    
    public var didSet: (([LogEntry]) -> Void)?
    
    public var willInsert: (() -> Void)?
    public var didInsert: (([Change]) -> Void)?
    
    public var willAppend: (() -> Void)?
    public var didAppend: (([Change]) -> Void)?
    
    public var configureCell: ((UITableViewCell, LogEntry) -> Void)?
    public var configureHeader: ((UIView, LogEntryGroup) -> Void)?
    
    public func prepend(entries:[LogEntry]) {
        guard entries.count > 0 else { return }
        willInsert?()
        offset += entries.count
        let changes = entries.map(self.prepend)
        didInsert?(changes)
    }
    
    public func append(entries:[LogEntry]) {
        guard entries.count > 0 else { return }
        willAppend?()
        offset += entries.count
        let changes = entries.map(self.append)
        didAppend?(changes)
    }
    
    public func set(entries:[LogEntry]) {
        groups = []
        offset = entries.count
        let _ = append(entries: entries)
        didSet?(entries)
    }
    
    public func getEntry(for indexPath:IndexPath) -> LogEntry {
        return groups[indexPath.section].entries[indexPath.row]
    }
    
    public func getGroup(forSection section:Int) -> LogEntryGroup {
        return groups[section]
    }
    
    public func count(forSection section:Int) -> Int {
        return groups[section].count
    }
    
    public var count: Int {
        return groups.count
    }
    
    // MARK: - Private
    private func append(entry:LogEntry) -> Change {
        if let section = groups.index(of: LogEntryGroup(entry: entry)) {
            groups[section].append(entry)
            let indexPath = IndexPath(row: groups[section].count - 1, section: section)
            return Change(indexPath: indexPath, createSection: false)
        } else {
            groups.append(LogEntryGroup(entry: entry))
            let indexPath = IndexPath(row: 0, section: groups.count - 1)
            return Change(indexPath: indexPath, createSection: true)
        }
    }
    
    private func prepend(entry:LogEntry) -> Change {
        if let section = groups.index(of: LogEntryGroup(entry: entry)) {
            groups[section].insert(entry, at: 0)
            let indexPath = IndexPath(row: 0, section: section)
            return Change(indexPath: indexPath, createSection: false)
        } else {
            groups.insert(LogEntryGroup(entry: entry), at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            return Change(indexPath: indexPath, createSection: true)
        }
    }
    
    private func insert(entry:LogEntry) -> Change? {
        let newGroup = LogEntryGroup(entry: entry)
        var indexPath:IndexPath?
        var createSession = false
        
        func wasInserted() -> Bool { return indexPath != nil }
        
        // Check if log entry belongs to a group
        if let section = groups.index(of: newGroup) {
            var group = groups[section]
            
            // Check where the entry should fit inside the group
            for row in 0..<group.count {
                // Doesn't insert if entry was inserted before
                if entry == group.entries[row] {
                    break
                }
                // Check if entry is newer
                if entry > group.entries[row] {
                    group.insert(entry, at: row)
                    indexPath = IndexPath(row: row, section: section)
                    break
                }
            }
            // If the entry was not inserted and append to the end
            if !wasInserted() {
                group.append(entry)
                indexPath = IndexPath(row: group.count - 1, section: section)
            }
        }
        // If it doesn't, create a new group and insert
        else {
            // Check where the group should be inserted
            for section in 0..<groups.count {
                if newGroup.timestamp > groups[section].timestamp {
                    groups.insert(newGroup, at: section)
                    indexPath = IndexPath(row: 0, section: section)
                    break
                }
            }
            
            // If the group wast not inserted, append to the end
            if !wasInserted() {
                groups.append(newGroup)
                indexPath = IndexPath(row: 0, section: groups.count - 1)
            }
            
            createSession = true
        }
        
        return wasInserted() ? Change(indexPath: indexPath!, createSection: createSession) : nil
    }
}

extension TimelineDatasource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count(forSection: section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineDatasource.cellIdentifier,
                                                 for: indexPath)
        self.configureCell?(cell, getEntry(for: indexPath))
        return cell
    }
}
