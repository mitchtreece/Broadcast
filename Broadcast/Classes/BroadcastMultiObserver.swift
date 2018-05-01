//
//  BroadcastMultiObserver.swift
//  Broadcast
//
//  Created by Mitch Treece on 4/30/18.
//

import Foundation

/**
 `BroadcastMultiObserver` is a holder of multiple `BroadcastObservers`.
 */
public class BroadcastMultiObserver {
    
    private var observers: [BroadcastObserver]
    
    public init(_ broadcastables: [Broadcastable], block: @escaping BroadcastObserver.Block) {
        self.observers = broadcastables.map({ $0.update(block) })
    }
    
}