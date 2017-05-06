//
//  ViewController.swift
//  BackLoggerExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit
import BackLogger

class ViewController: UIViewController {
    private var timer:Timer?
    
    @IBAction func debugTapped() {
        debug(message: "Some debug message. Active only when #DEBUG is true")
    }
    
    @IBAction func infoTapped() {
        info(message: "A info message. Let's try some multiline\nmessage to see\nwhat whe can do...\nsome\nmore\nlines...\n1)\n2)\n3)")
    }
        
    @IBAction func warnTapped() {
        warn(message: "This is a warning message. Something is wrong...")
    }
    
    @IBAction func errorTapped() {
        error(message: "This is a fail message. Something is really bad right now...")
    }
    
    @IBAction func viewLogTapped() {
        self.present(BackLoggerViewController(), animated: true)
    }
    
    @IBAction func startLogChanged(sender:UISwitch) {
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: 2,
                                         target: self,
                                         selector: #selector(debugTapped),
                                         userInfo: nil,
                                         repeats: true)
        } else {
            timer?.invalidate()
        }
    }
}

