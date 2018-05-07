//
//  BroadcastListener+Group.swift
//  Broadcast
//
//  Created by Mitch Treece on 5/4/18.
//

import Foundation

/**
 `BroadcastGroupListener` is an observer over multiple `Broadcastable` object's signal & update events.
 */
public class BroadcastGroupListener {
    
    /**
     A notification closure for a `BroadcastGroupListener`.
     - Parameter object: The source `Broadcastable` object.
     */
    public typealias Block = (_ object: Broadcastable)->()
    
    private var listeners: [BroadcastListener]
    
    internal init(_ listeners: [BroadcastListener]) {
        self.listeners = listeners
    }
    
}

public extension Array where Element: Broadcastable {
    
    /**
     Creates a `BroadcastGroupListener` over multiple `Broadcastable` objects using a given handler block.
     - Note: You must keep a reference to the returned listener.
     - Parameter block: The update handler.
     - Returns: A new `BroadcastGroupListener` instance.
     */
    public func listen(_ block: @escaping BroadcastGroupListener.Block) -> BroadcastGroupListener {
        return BroadcastListener.for(self, block)
    }
    
}

internal extension BroadcastListener {
    
    internal static func `for`(_ objects: [Broadcastable], _ block: @escaping BroadcastGroupListener.Block) -> BroadcastGroupListener {
        
        let _block: BroadcastListener.NotificationBlock = { (notification) in
            guard let object = notification.object as? Broadcastable else { return }
            block(object)
        }
        
        let listeners = objects.map { (object)->(BroadcastListener) in
            let info = NotificationInfo(baseName: "\(object.typeId)_\(object.broadcastId)")
            return BroadcastListener(name: info.updateName, object: object, block: _block)
        }
        
        return BroadcastGroupListener(listeners)
        
    }
    
}
