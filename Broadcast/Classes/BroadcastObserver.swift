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
    
    internal init(name: String, object: AnyObject?, block: (NSNotification) -> ()) {
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(name, object: object, queue: NSOperationQueue.mainQueue(), usingBlock: block)
        self.name = name
    }
    
    deinit {
        if let observer = observer {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
    
}