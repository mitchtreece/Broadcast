//
//  Listener.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

/**
 `BroadcastListener` is an observer over a `Broadcastable` object's signal & update events.
 */
public class BroadcastListener {
    
    /**
     A notification closure for a `Listener`.
     - Parameter notification: The source `Notification`.
     */
    public typealias NotificationBlock = (_ notification: Notification)->()
    
    private let observer: Any?
    private let name: String

    internal static func `for`(_ object: Broadcastable, block: @escaping VoidBlock) -> BroadcastListener {
        
        let _block: NotificationBlock = { _ in block() }
        let info = NotificationInfo(baseName: "\(object.typeId)_\(object.broadcastId)")
        return BroadcastListener(name: info.updateName, object: object, block: _block)
        
    }
    
    internal init(name: String, object: Any?, block: @escaping NotificationBlock) {
        
        let notificationName = Notification.Name(name)
        self.observer = NotificationCenter.default.addObserver(forName: notificationName, object: object, queue: OperationQueue.main, using: block)
        self.name = name
        
    }
    
    deinit {
        
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
        
    }
    
}
