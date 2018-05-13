//
//  Broadcast.swift
//  Broadcast
//
//  Created by Mitch Treece on 4/30/18.
//

import Foundation

/// A `Void` closure.
public typealias VoidBlock = ()->()

/**
 A `Broadcastable` object's underlying `Broadcast` instance.
 This object handles signaling & listening for events.
 */
public class Broadcast<T: Broadcastable> {
    
    /**
     A closure for a `signal` event.
     - Parameter object: The "proxy" `Broadcastable` object.
     */
    public typealias SignalBlock = (_ object: T)->()
    
    private unowned var object: T
    private var signalListener: BroadcastListener?
    
    internal init(_ object: T) {
        self.object = object
    }
    
    /**
     Prepares the `Broadcast` object for signal & update events.
     - Precondition: `make()` must be called **before** signaling events.
     
     ## Example: ##
     ```
     class User: Broadcastable {
     
        var name: String
        var age: Int
     
        var broadcastId: String {
            return "\(name)_\(age)"
        }
     
        init(name: String, age: Int) {
            self.name = name
            self.age = age
            self.broadcast.make()
        }
     
     }
     ```
     */
    public func make() {
        
        signalListener = BroadcastListener(name: object.notificationInfo.signalName, object: nil, block: { [weak self] (notification) in
            
            guard let _self = self else { return }
            guard let info = notification.userInfo,
                let container = info[BlockContainer.key] as? BlockContainer,
                let block = container.block else { return }
            
            block(_self.object)
            _self.postUpdateNotification()
            
        })
        
    }
    
    /**
     Broadcasts changes made within the closure to other instances of the current object.
     - Parameter block: The signal block.
     */
    public func signal(_ block: @escaping SignalBlock) {

        let typeErasedBlock: (Any)->() = { block($0 as! T) }
        let container = BlockContainer(block: typeErasedBlock)
        let info: [String: Any] = [BlockContainer.key: container]
        NotificationCenter.default.post(name: Notification.Name(object.notificationInfo.signalName), object: nil, userInfo: info)
        
    }
    
    /**
     Creates a `BroadcastListener` for a `Broadcastable` object's update event.
     - Note: You must keep a reference to the returned listener.
     - Parameter block: The update handler.
     */
    public func listen(_ block: @escaping VoidBlock) -> BroadcastListener {
        return BroadcastListener.for(object, block: block)
    }
    
    private func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(object.notificationInfo.updateName), object: object, userInfo: nil)
    }
    
}
