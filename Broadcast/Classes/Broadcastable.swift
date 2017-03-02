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
public typealias BroadcastBlockObjC = (Any)->()
public typealias BroadcastUpdateBlock = (Notification)->()

/**
 `BroadcastBlockContainer` is an internal object used to pass synchronization blocks around.
 Unfortunately, to make this accessible to our `BroadcastableObject` Objective-C counterpart,
 This class needs to be marked public. This **should not** be used directly.
 */
public class BroadcastBlockContainer: NSObject {
    
    public static let key = "BroadcastBlockContainer.key"
    public private(set) var block: BroadcastBlock?
    public private(set) var block_objc: BroadcastBlockObjC?
    
    public init(block: @escaping BroadcastBlock) {
        self.block = block
    }
    
    public init(block_objc: @escaping BroadcastBlockObjC) {
        self.block_objc = block_objc
    }
    
}

/**
 The `Broadcastable` protocol defines an object that can notify and react when changes occur.
 Objects wishing to conform to `Broadcastable` simply need to supply a `broadcastId` & call
 `makeBroadcastable()` upon initialization (or anytime before calls to `synchronize()` happen).
 */
public protocol Broadcastable: class {
    
    var broadcastId: String { get }
    func synchronize(_ block: @escaping BroadcastBlock)
    func update(_ block: @escaping BroadcastUpdateBlock) -> BroadcastObserver
    func makeBroadcastable()
    
}

public extension Broadcastable /* Broadcasts */ {
    
    // MARK: Internal
    
    internal func broadcastNotificationName() -> String {
        
        return NSStringFromClass(type(of: self)) + "_" + broadcastId
        
    }
    
    // MARK: Public
    
    /**
     Registers & creates an observer for broadcast events based on an object's `broadcastId` property.
     If you change an object's `broadcastId`, you **must** call `makeBroadcastable()` again.
     */
    public func makeBroadcastable() {
        
        let observer = BroadcastObserver(name: broadcastNotificationName() + ".synchronize", object: nil) { [weak self] (notification) in
            
            guard let _self = self else { return }
            guard let info = notification.userInfo, let container = info[BroadcastBlockContainer.key] as? BroadcastBlockContainer else { return }
            guard let block = container.block else { return }
            
            block(_self)
            _self.updateNotify()
            
        }
        
        objc_setAssociatedObject(self, &BroadcastObserverAssociationToken, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    /**
     Synchronizes changes made within the closure to other instances of an object.
     */
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
