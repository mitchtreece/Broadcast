//
//  Broadcastable.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

internal var BroadcastObserverAssociationToken: UInt8 = 0

public typealias BroadcastBlock = ()->()
public typealias BroadcastUpdateBlock = (Notification)->()

internal class BroadcastBlockContainer: NSObject {
    
    static let key = "BroadcastBlockContainer.key"
    var block: BroadcastBlock
    
    init(block: @escaping BroadcastBlock) {
        self.block = block
    }
    
}

/**
 The `Broadcastable` protocol defines an object that can notify and react when property changes occur.
 Objects wishing to conform to `Broadcastable` simply need to supply a `broadcastId`.
 */
public protocol Broadcastable: class {
    
    var broadcastId: String { get }
    
}

public extension Broadcastable /* Broadcasts */ {
    
    // MARK: Internal
    
    internal func setupBroadcastObserver() {
        
        let observer = BroadcastObserver(name: broadcastNotificationName() + ".synchronize", object: nil) { [weak self] (notification) in
            
            guard let _self = self else { return }
            guard let info = (notification as Notification).userInfo, let container = info[BroadcastBlockContainer.key] as? BroadcastBlockContainer else { return }
            
            container.block()            
            _self.updateNotify()
            
        }
        
        objc_setAssociatedObject(self, &BroadcastObserverAssociationToken, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    internal func broadcastNotificationName() -> String {
        
        return NSStringFromClass(type(of: self)) + "_" + broadcastId
        
    }
    
    // MARK: Public
    
    func synchronize(_ block: @escaping BroadcastBlock) {
        
        if objc_getAssociatedObject(self, &BroadcastObserverAssociationToken) == nil {
            setupBroadcastObserver()
        }
        
        let container = BroadcastBlockContainer(block: block)
        let info: [String: Any] = [BroadcastBlockContainer.key: container]
        NotificationCenter.default.post(name: Notification.Name(rawValue: broadcastNotificationName() + ".synchronize"), object: nil, userInfo: info)

    }
    
}

public extension Broadcastable /* Updates */ {
    
    // MARK: Internal
    
    internal func updateNotify() {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: broadcastNotificationName() + ".update"), object: self, userInfo: nil)
        
    }
    
    // MARK: Public
    
    func update(_ block: @escaping BroadcastUpdateBlock) -> BroadcastObserver {
        
        return BroadcastObserver(name: broadcastNotificationName() + ".update", object: self, block: block)
        
    }
    
}
