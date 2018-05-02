//
//  Broadcast.swift
//  Broadcast
//
//  Created by Mitch Treece on 4/30/18.
//

import Foundation

private class BroadcastBlockContainer {
    
    static let key = "BroadcastBlockContainer.key"
    private(set) var block: ((Any)->())?
    
    init(block: @escaping (Any)->()) {
        self.block = block
    }
    
}

private struct BroadcastNotificationInfo {
    
    private(set) var baseName: String
    private let signalPostfix = "signal"
    private let updatePostfix = "update"
    
    var signalName: String {
        return "\(baseName).\(signalPostfix)"
    }
    
    var updateName: String {
        return "\(baseName).\(updatePostfix)"
    }
    
}

public class Broadcast<T: Broadcastable> {
    
    public typealias SignalBlock = (T)->()
    public typealias UpdateBlock = ()->()
    
    internal(set) weak var broadcastable: Broadcastable?
    private var notificationInfo: BroadcastNotificationInfo
    
    private var signalObserver: BroadcastObserver?
    private var updateObserver: BroadcastObserver?
    
    internal init(_ broadcastable: Broadcastable) {
        
        self.broadcastable = broadcastable
        self.notificationInfo = BroadcastNotificationInfo(baseName: "\(broadcastable.typeId)_\(broadcastable.broadcastId)")
        
    }
    
    public func make() {
        
        signalObserver = BroadcastObserver(name: notificationInfo.signalName, object: nil, block: { [weak self] (notification) in
            
            guard let _self = self else { return }
            guard let _broadcastable = _self.broadcastable else { return }
            guard let info = notification.userInfo,
                let container = info[BroadcastBlockContainer.key] as? BroadcastBlockContainer,
                let block = container.block else { return }
            
            block(_broadcastable)
            _self.postUpdateNotification()
            
        })
                
    }
    
    public func signal(_ block: @escaping SignalBlock) {

        // TODO: Check that observer isn't nil? (i.e. make() was called)
        
        let typeErasedBlock: (Any)->() = { block($0 as! T) }
        let container = BroadcastBlockContainer(block: typeErasedBlock)
        let info: [String: Any] = [BroadcastBlockContainer.key: container]
        NotificationCenter.default.post(name: Notification.Name(notificationInfo.signalName), object: nil, userInfo: info)
        
    }
    
    public func listen(_ block: @escaping UpdateBlock) {
        
        let _block: (Notification)->() = { _ in block() }
        updateObserver = BroadcastObserver(name: notificationInfo.updateName, object: self.broadcastable, block: _block)
        
    }
    
    private func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(notificationInfo.updateName), object: self.broadcastable, userInfo: nil)
    }
    
}
