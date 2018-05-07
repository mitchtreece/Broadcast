//
//  Listener+Multi.swift
//  Broadcast
//
//  Created by Mitch Treece on 5/4/18.
//

import Foundation

/**
 `MultiListener` is an observer over multiple `Broadcastable` object's signal & update events.
 */
public class MultiListener {
    
    /**
     A notification closure for a `MultiListener`.
     - Parameter object: The source `Broadcastable` object.
     */
    public typealias Block = (_ object: Broadcastable)->()
    
    private var listeners: [Listener]
    
    internal init(_ listeners: [Listener]) {
        self.listeners = listeners
    }
    
}

public extension Listener {
    
    /**
     Creates a `MultiListener` over multiple `Broadcastable` objects using a given handler block.
     - Note: You must keep a reference to the returned listener.
     - Parameter objects: The `Broadcastable` objects.
     - Parameter block: The handler for this listener.
     - Returns: A new `MultiListener` instance.
     */
    public static func `for`(_ objects: [Broadcastable], _ block: @escaping MultiListener.Block) -> MultiListener {
        
        let _block: Listener.NotificationBlock = { (notification) in
            guard let object = notification.object as? Broadcastable else { return }
            block(object)
        }
        
        let listeners = objects.map { (object) -> (Listener) in
            let info = NotificationInfo(baseName: "\(object.typeId)_\(object.broadcastId)")
            return Listener(name: info.updateName, object: object, block: _block)
        }
        
        return MultiListener(listeners)
        
    }
    
}
