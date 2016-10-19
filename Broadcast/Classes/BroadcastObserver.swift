//
//  BroadcastObserver.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

/**
 `BroadcastObserver` is a simple block-based wrapper over `NotificationCenter` observation.
 */
public class BroadcastObserver {
    
    private let observer: Any?
    private let name: String
    
    internal init(name: String, object: Any?, block: @escaping (Notification) -> ()) {
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: object, queue: OperationQueue.main, using: block)
        self.name = name
        
    }
    
    deinit {
        
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
        
    }
    
}
