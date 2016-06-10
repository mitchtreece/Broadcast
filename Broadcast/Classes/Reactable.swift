//
//  Reactable.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//
//

import Foundation

public typealias ReactBlock = (NSNotification) -> ()

public protocol Reactable: class {
    
    var reactId: String { get }
    
}

public extension Reactable {
    
    func react(block: ReactBlock) -> ReactObserver {
        return ReactObserver(name: notificationName(), object: self, block: block)
    }
    
    func broadcast() {
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName(), object: self, userInfo: nil)
    }
    
    internal func notificationName() -> String {
        return NSStringFromClass(self.dynamicType) + "_" + reactId + ".react"
    }
    
}