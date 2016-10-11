//
//  BroadcastObserver.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

public typealias SyncObserver = BroadcastObserver
public typealias ReactObserver = BroadcastObserver

/**
 `BroadcastObserver` is a simple block-based wrapper over `NSNotificationCenter` observation.
 */
public class BroadcastObserver {
    
    private let observer: AnyObject?
    private let name: String
    
    internal init(name: String, object: AnyObject?, block: @escaping (Notification) -> ()) {
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: object, queue: OperationQueue.main, using: block)
        self.name = name
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}
