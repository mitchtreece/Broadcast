//
//  Listener.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

/**
 `Listener` is an observer over a `Broadcastable` object's signal & update events.
 */
public class Listener {
    
    /**
     A notification closure for a `Listener`.
     - Parameter notification: The source `Notification`.
     */
    public typealias NotificationBlock = (_ notification: Notification)->()
    
    private let observer: Any?
    private let name: String
    
    /**
     Creates a `Listener` for a `Broadcastable` object using a given handler block.
     - Note: You must keep a reference to the returned listener.
     - Parameter object: The `Broadcastable` object.
     - Parameter block: The handler for this listener.
     - Returns: A new `Listener` instance.
     */
    public static func `for`(_ object: Broadcastable, block: @escaping VoidBlock) -> Listener {
        
        let _block: NotificationBlock = { _ in block() }
        let info = NotificationInfo(baseName: "\(object.typeId)_\(object.broadcastId)")
        return Listener(name: info.updateName, object: object, block: _block)
        
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
