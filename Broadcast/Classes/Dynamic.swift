//
//  Dynamic.swift
//  Pods
//
//  Created by Mitch Treece on 6/10/16.
//
//

import Foundation

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