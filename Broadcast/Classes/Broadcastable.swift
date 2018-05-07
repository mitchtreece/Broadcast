//
//  Broadcastable2.swift
//  Broadcast
//
//  Created by Mitch Treece on 4/30/18.
//

import Foundation

private struct AssociatedKeys {
    static let BroadcastKey = "Broadcastable.broadcast"
}

/**
 The `Broadcastable` protocol defines an object that can signal and react to changes from other instances of itself.
 - Precondition: `broadcast.make()` must be called **before** signaling events.
 
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
public protocol Broadcastable: class {
    
    /// The `Broadcastable` object's instance identifier.
    var broadcastId: String { get }
    
}

public extension Broadcastable {
    
    /**
     The underlying `Broadcast` object that handles signaling and listening for events.
     */
    public private(set) var broadcast: Broadcast<Self> {
        get {
            
            guard let _broadcast = objc_getAssociatedObject(self, AssociatedKeys.BroadcastKey) as? Broadcast<Self> else {
                
                let _broadcast = Broadcast<Self>(self)
                objc_setAssociatedObject(self, AssociatedKeys.BroadcastKey, _broadcast, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return _broadcast
                
            }
            
            return _broadcast
            
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.BroadcastKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     The `Broadcastable` object's type identifier.
     */
    public var typeId: String {
        return String(describing: type(of: self))
    }
    
    /**
     The `Broadcastable` object's underlying notification info used for events.
     */
    public var notificationInfo: NotificationInfo {
        return NotificationInfo(baseName: "\(typeId)_\(broadcastId)")
    }
    
}
