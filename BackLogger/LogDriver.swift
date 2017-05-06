//
//  LogDriver.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import Foundation

public typealias DidLogCallback = ((LogEntry) -> Void)

public protocol LogDriver:class {
    func log(entry:LogEntry)
    func all(byType typeOrNil:LogType?, offset:Int) -> [LogEntry]?
    var didLog: DidLogCallback? { get set }
}
