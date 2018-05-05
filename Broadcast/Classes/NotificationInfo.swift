//
//  NotificationInfo.swift
//  Broadcast
//
//  Created by Mitch Treece on 5/4/18.
//

import Foundation

public struct NotificationInfo {
    
    public private(set) var baseName: String
    private let signalPostfix = "signal"
    private let updatePostfix = "update"
    
    public var signalName: String {
        return "\(baseName).\(signalPostfix)"
    }
    
    public var updateName: String {
        return "\(baseName).\(updatePostfix)"
    }
    
}
