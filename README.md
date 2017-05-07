# Background Log Manager
If you like background log manager, give us a ⭐️

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## How it works

![How it works](https://media.giphy.com/media/26FmQDKouh2j3z29i/giphy.gif)

BackLogger is a simple log manager that uses a superfast SqlLite database to store your logs.

- [x] Four types of log: `debug`, `info`, `warn`, `error`
- [x] Log **file**, **function**, **line** 
- [x] Swift 3.0
- [x] Really Fast!
- [x] Nice log viewer interface
- [x] Log drivers: Console and Sql drivers included. You can write your own driver if you need
- [x] Highly customizable
- [x] Well documented
- [x] and more...

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate BackLogger into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'BackLogger'
```

Then, run the following command:

```bash
$ pod install
```

If you want to use our log viewer add this line to your `Podfile`:
```ruby
pod 'BackLogger/UI'
```

`Backlogger UI` requires minimum **iOS 9**.

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SideMenu into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "leoneparise/backlogger" "master"
```
## Usage

Backlogger provides 4 log functions:

```swift
debug(message:String)
```

```swift
info(message:String)
```

```swift
warn(message:String)
```

```swift
error(message:String)
```

Under the hood, these functions uses `LogManager` shared instance to log your data. `LogManager` is the Backlogger's main class and has the following signature:

```swift
public class LogManager {
  /// Callback used to receive a log event. This function is called when ANY LogManager saves a log.
  public var didLog: DidLogCallback?
  
  /// Drivers
  public var drivers: [LogDriver]
    
  /// Main driver is always the first driver in drivers attribute.
  public var mainDriver: LogDriver?
  
  /// Share instance. Can be customized to meed your needs
  public static var shared: LogManager
    
  /// Get all logs. Depends if the mainDriver provides this feature
  public func all(byType type: LogType? = nil, offset: Int = 0) -> [LogEntry]?
  
  /// Log into all drivers
  public func log(file: String = #file, line: UInt = #line, function: String = #function, type: LogType = .debug, message: String)  
}
```

To disable the log database in prodution, put this code in your `application(_:didFinishLaunchWithOptions:)` method:
```swift
if let sqlLogDriver = SqlLogDriver(), let consoleLogDriver = ConsoleLogDriver() {
    #if DEBUG
        LogManager.shared.drivers = [sqlLogDriver, consoleLogDriver]
    #else
        LogManager.shared.drivers = [consoleLogDriver]
    #endif
}
```
If you want to receive log events, you can use the `NotificationCenter` and listen to `Notification.Name.LogManagerDidLog` notification. The object is the `LogEntry` struct used to store logs. You can achieve the same result setting the function `didLog` in **ANY** `LogManager` instance.

### Backlogger UI

To view your logs you can use our `Log Viewer` view controller. Just instantiate our `BackLoggerViewController` and prent in your code:

```swift
self.present(BackLoggerViewController(), animated: true)
```

# TODO
- [x] Save to server in background
- [x] Evict past logs
- [x] Filter and search in Log Viewer View Controller.
