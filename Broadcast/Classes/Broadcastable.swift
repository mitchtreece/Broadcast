//
//  Broadcastable.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

public var BroadcastObserverAssociationToken: UInt8 = 0

public typealias BroadcastBlock = (Broadcastable)->()
public typealias BroadcastUpdateBlock = (Notification)->()

public class BroadcastBlockContainer: NSObject {
    
    public static let key = "BroadcastBlockContainer.key"
    public private(set) var block: BroadcastBlock
    
    public init(block: @escaping BroadcastBlock) {
        self.block = block
    }
    
}

/**
 The `Broadcastable` protocol defines an object that can notify and react when property changes occur.
 Objects wishing to conform to `Broadcastable` simply need to supply a `broadcastId`.
 */
@objc public protocol Broadcastable: class {
    
    var broadcastId: String { get }
    
    @objc(synchronize:)
    optional func synchronize(_ block: @escaping BroadcastBlock)
    
    @objc(update:)
    optional func update(_ block: @escaping BroadcastUpdateBlock) -> BroadcastObserver
    
    @objc func makeBroadcastable()
    
}

public extension Broadcastable /* Broadcasts */ {
    
    // MARK: Internal
    
    public func makeBroadcastable() {
        
        let observer = BroadcastObserver(name: broadcastNotificationName() + ".synchronize", object: nil) { [weak self] (notification) in

            guard let _self = self else { return }
            guard let info = notification.userInfo, let container = info[BroadcastBlockContainer.key] as? BroadcastBlockContainer else { return }

            container.block(_self)
            _self.updateNotify()
            
        }
        
        objc_setAssociatedObject(self, &BroadcastObserverAssociationToken, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    internal func broadcastNotificationName() -> String {
        
        return NSStringFromClass(type(of: self)) + "_" + broadcastId
        
    }
    
    // MARK: Public
    
    public func synchronize(_ block: @escaping BroadcastBlock) {
        
        let container = BroadcastBlockContainer(block: block)
        let info: [String: Any] = [BroadcastBlockContainer.key: container]
        let name = broadcastNotificationName() + ".synchronize"
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: info)

    }
    
}

public extension Broadcastable /* Updates */ {
    
    // MARK: Internal
    
    internal func updateNotify() {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: broadcastNotificationName() + ".update"), object: self, userInfo: nil)
        
    }
    
    // MARK: Public
    
    public func update(_ block: @escaping BroadcastUpdateBlock) -> BroadcastObserver {
        
        return BroadcastObserver(name: broadcastNotificationName() + ".update", object: self, block: block)
        
    }
    
}
