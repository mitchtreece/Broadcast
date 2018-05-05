//
//  Listener+Multi.swift
//  Broadcast
//
//  Created by Mitch Treece on 5/4/18.
//

import Foundation

/**
 `MultiListener` is an observer over multiple `Broadcastable` object update events.
 */
public class MultiListener {
    
    public typealias Block = (Broadcastable)->()
    
    private var listeners: [Listener]
    
    internal init(_ listeners: [Listener]) {
        self.listeners = listeners
    }
    
}

public extension Listener {
    
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
