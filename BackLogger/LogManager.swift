//
//  Logger.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 05/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import Foundation

public func debug(file:String = #file, line:UInt = #line, function:String = #function, message:String) {
    LogManager.shared.log(file: file, line: line, function: function, type: .debug, message: message)
}

public func info(file:String = #file, line:UInt = #line, function:String = #function, message:String) {
    LogManager.shared.log(file: file, line: line, function: function, type: .info, message: message)
}

public func warn(file:String = #file, line:UInt = #line, function:String = #function, message:String) {
    LogManager.shared.log(file: file, line: line, function: function, type: .warn, message: message)
}

public func error(file:String = #file, line:UInt = #line, function:String = #function, message:String) {
    LogManager.shared.log(file: file, line: line, function: function, type: .error, message: message)
}

extension Notification.Name {
    static let LogManagerDidLog = Notification.Name("LogManagerDidLog")
}

public class LogManager {
    // MARK: Public
    public var didLog: DidLogCallback?
    public var drivers: [LogDriver] = [] {
        didSet { didSetDrivers() }
    }
    
    public var mainDriver: LogDriver? {
        return drivers.first
    }
    
    public static var shared: LogManager = {
        let drivers:[LogDriver?] = [SqlLogDriver(), ConsoleLogDriver()]
        return LogManager(drivers: drivers.removeNils())
    }()
    
    public init(drivers: [LogDriver]) {
        self.drivers = drivers
        didSetDrivers()
        
        
        // Configure observers
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(onLogNotification(notification:)),
                         name: Notification.Name.LogManagerDidLog,
                         object: nil)
    }
    
    public func all(byType type: LogType? = nil, offset: Int = 0) -> [LogEntry]? {
        return self.mainDriver?.all(byType: type, offset: offset)
    }
    
    public func log(file: String = #file, line: UInt = #line, function: String = #function, type: LogType = .debug, message: String) {
        let fileName = file.components(separatedBy: "/").last ?? ""
        let entry = LogEntry(createdAt: Date(), order: nil, type: type, file: fileName, line: line, function: function, message: message)
        
        for driver in drivers {
            driver.log(entry: entry)
        }
    }
    
    // MARK: Private
    private func didSetDrivers() {
        if let driver = self.mainDriver {
            driver.didLog = {[weak self] entry in
                self?.postDidLogNotification(entry: entry)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Notification
extension LogManager {
    @objc fileprivate func onLogNotification(notification: Notification) {
        guard let entry = notification.object as? LogEntry else { return }
        self.didLog?(entry)
    }
    
    fileprivate func postDidLogNotification(entry: LogEntry) {
        NotificationCenter.default.post(name: Notification.Name.LogManagerDidLog, object: entry)
    }
}
