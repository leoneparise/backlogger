//
//  TimelineViewController.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 05/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit

public class TimelineViewController: UITableViewController {
    open var dataSource:TimelineDatasource!
    private var logManager:LogManager!
    
    open var logFile:String = {
        return "logs.sqlite3"
    }()
    open var fetchThreshold = 5
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Log Viewer"
        
        // Configure log manager
        logManager = LogManager(drivers: [SqlLogDriver(logFile:self.logFile)].removeNils())
        logManager.didLog = {[unowned self] entry in
            self.dataSource.prepend(entries: [entry])
        }
        
        // Configure datasource
        if dataSource == nil {
            dataSource = TimelineDatasource()
        }
        
        dataSource.configureCell = { cell, entry in
            guard let entryCell = cell as? TimelineTableViewCell else { return }
            entryCell.type = entry.type
            entryCell.file = entry.file
            entryCell.line = entry.line
            entryCell.message = entry.message
            entryCell.createdAt = entry.createdAt
        }
        
        dataSource.didAppend = { [unowned self] _ in
            self.tableView.reloadData()
        }
        
        dataSource.didSet = { [unowned self] _ in
            self.tableView.reloadData()
        }
        
        dataSource.willInsert = { [unowned self] in
            self.tableView.beginUpdates()
        }
        
        dataSource.didInsert = { [unowned self] changes in
            for change in changes {
                if change.createSection {
                    self.tableView.insertSections([change.indexPath.section], with: .top)
                }
                self.tableView.insertRows(at: [change.indexPath], with: .top)
            }
            self.tableView.endUpdates()
        }
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 50
        
        // Register cell
        let bundle = Bundle(for: TimelineViewController.self)
        let cellNib = UINib(nibName: "TimelineTableViewCell", bundle: bundle)
        tableView.register(cellNib, forCellReuseIdentifier: TimelineDatasource.cellIdentifier)
        
        // Configure navigation bar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(close))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let logs = logManager.all() else { return }
        self.dataSource.set(entries: logs)
    }
    
    override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TimelineTableViewHeader.fromNib()
        view.isFirst = section == 0
        view.date = dataSource.getGroup(forSection: section).timestamp
        return view
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let (section, row) = (indexPath.section, indexPath.row)
        
        if section - 1 == dataSource.count &&
           row >= dataSource.count(forSection: section) - fetchThreshold,
           let logs = logManager.all(offset: dataSource.offset) {
            dataSource.append(entries: logs)
        }
    }
        
    @objc private func close() {
        if let nav = self.navigationController {
            nav.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
