//
//  NotificationInfo.swift
//  Broadcast
//
//  Created by Mitch Treece on 5/4/18.
//

import Foundation

/**
 `NotificationInfo` is a container for a `Broadcastable` object's signal & update notification names.
 */
internal struct NotificationInfo {
    
    /// The notification's base name.
    public private(set) var baseName: String
    private let signalPostfix = "signal"
    private let updatePostfix = "update"
    
    /// The notification's full signal event name.
    public var signalName: String {
        return "\(baseName).\(signalPostfix)"
    }
    
    /// The notification's full update event name.
    public var updateName: String {
        return "\(baseName).\(updatePostfix)"
    }
    
}
