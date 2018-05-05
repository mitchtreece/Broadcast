//
//  Broadcast.swift
//  Broadcast
//
//  Created by Mitch Treece on 4/30/18.
//

import Foundation

public typealias VoidBlock = ()->()

public func listen(to objects: [Broadcastable], _ block: @escaping VoidBlock) -> MultiListener {
    
    let _block: Listener.NotificationBlock = { _ in block() }
    
    let listeners = objects.map { (object) -> (Listener) in
        let info = NotificationInfo(baseName: "\(object.typeId)_\(object.broadcastId)")
        return Listener(name: info.updateName, object: object, block: _block)
    }
    
    return MultiListener(listeners)
    
}

public class Broadcast<T: Broadcastable> {
    
    public typealias SignalBlock = (T)->()
    
    internal(set) unowned var object: T
    private var signalListener: Listener?
    
    internal init(_ object: T) {
        self.object = object
    }
    
    public func make() {
        
        signalListener = Listener(name: object.notificationInfo.signalName, object: nil, block: { [weak self] (notification) in
            
            guard let _self = self else { return }
            guard let info = notification.userInfo,
                let container = info[BlockContainer.key] as? BlockContainer,
                let block = container.block else { return }
            
            block(_self.object)
            _self.postUpdateNotification()
            
        })
        
    }
    
    public func signal(_ block: @escaping SignalBlock) {

        let typeErasedBlock: (Any)->() = { block($0 as! T) }
        let container = BlockContainer(block: typeErasedBlock)
        let info: [String: Any] = [BlockContainer.key: container]
        NotificationCenter.default.post(name: Notification.Name(object.notificationInfo.signalName), object: nil, userInfo: info)
        
    }
    
    public func listen(_ block: @escaping VoidBlock) -> Listener {
        return Listener.for(object, block: block)
    }
    
    private func postUpdateNotification() {
        NotificationCenter.default.post(name: Notification.Name(object.notificationInfo.updateName), object: object, userInfo: nil)
    }
    
}
