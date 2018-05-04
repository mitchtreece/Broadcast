//
//  Broadcastable2.swift
//  Broadcast
//
//  Created by Mitch Treece on 4/30/18.
//

import Foundation

public protocol Broadcastable: class {
    var broadcastId: String { get }
}

private struct AssociatedKeys {
    static let BroadcastKey = "Broadcastable.broadcast"
}

public extension Broadcastable {
    
    private(set) var broadcast: Broadcast<Self> {
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
    
}

internal extension Broadcastable {
    
    var broadcastTypeId: String {
        return String(describing: type(of: self))
    }
    
}
