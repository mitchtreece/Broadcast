//
//  Dynamic.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//  Broadcast
//

import Foundation

/**
 The `Dynamic` protocol is a composition of the `Syncable` and `Reactable` protocols.
 When an object conforms to the `Dynamic` protocol, it only needs to supply a `dynamicId`.
 This identifier will be used for both it's `syncId`, and `reactId`.
 */
public protocol Dynamic: Syncable, Reactable {
    
    var dynamicId: String { get }
    
}

public extension Dynamic {
    
    var syncId: String {
        return dynamicId
    }
    
    var reactId: String {
        return dynamicId
    }
    
}