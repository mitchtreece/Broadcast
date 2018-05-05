//
//  Listener.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

/**
 `Listener` is an observer over a `Broadcastable` object update event.
 */
@objcMembers
public class Listener: NSObject {
    
    public typealias NotificationBlock = (Notification)->()
    
    private let observer: Any?
    private let name: String
    
    public static func `for`(_ object: Broadcastable, block: @escaping VoidBlock) -> Listener {
        
        let _block: NotificationBlock = { _ in block() }
        let info = NotificationInfo(baseName: "\(object.typeId)_\(object.broadcastId)")
        return Listener(name: info.updateName, object: object, block: _block)
        
    }
    
    internal init(name: String, object: Any?, block: @escaping NotificationBlock) {
        
        let notificationName = Notification.Name(name)
        self.observer = NotificationCenter.default.addObserver(forName: notificationName, object: object, queue: OperationQueue.main, using: block)
        self.name = name
        
    }
    
    deinit {
        
        guard let observer = observer else { return }
        NotificationCenter.default.removeObserver(observer)
        
    }
    
}
