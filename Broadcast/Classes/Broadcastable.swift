//
//  Broadcastable.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

public typealias BroadcastUpdateBlock = (Notification) -> ()

internal var BroadcastObserverAssociationToken: UInt8 = 0

public typealias BroadcastBlock = (Broadcastable) -> ()

internal class BroadcastBlockContainer: NSObject {
    
    static let key = "BroadcastBlockContainer.key"
    var block: BroadcastBlock
    
    init(block: @escaping BroadcastBlock) {
        self.block = block
    }
    
}

/**
 The `Dynamic` protocol is a composition of the `Syncable` and `Reactable` protocols.
 When an object conforms to the `Dynamic` protocol, it only needs to supply a `dynamicId`.
 This identifier will be used for both it's `syncId`, and `reactId`.
 */
public protocol Broadcastable: class {
    
    var broadcastId: String { get }
    
}

public extension Broadcastable {
    
    func makeSyncable() {
        
        let observer = BroadcastObserver(name: broadcastNotificationName(), object: nil) { [weak self] (notification) in
            
            guard let localSelf = self else { return }
            guard let info = (notification as NSNotification).userInfo, let container = info[BroadcastBlockContainer.key] as? BroadcastBlockContainer else { return }
            
            container.block(localSelf)
            
            // Broadcast the react update
            localSelf.notify()
            
        }
        
        objc_setAssociatedObject(self, &BroadcastObserverAssociationToken, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    func broadcast(_ block: @escaping BroadcastBlock) {

        let container = BroadcastBlockContainer(block: block)
        let info: [String: AnyObject] = [BroadcastBlockContainer.key: container]
        NotificationCenter.default.post(name: Notification.Name(rawValue: broadcastNotificationName()), object: nil, userInfo: info)

    }
    
    internal func broadcastNotificationName() -> String {
        
        return NSStringFromClass(type(of: self)) + "_" + broadcastId + ".broadcast"
        
    }
    
}

public extension Broadcastable {
    
    func update(_ block: @escaping BroadcastUpdateBlock) -> BroadcastObserver {
        
        return BroadcastObserver(name: updateNotificationName(), object: self, block: block)
        
    }
    
    internal func notify() {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: updateNotificationName()), object: self, userInfo: nil)
        
    }
    
    internal func updateNotificationName() -> String {
        
        return NSStringFromClass(type(of: self)) + "_" + broadcastId + ".update"
        
    }
    
}
