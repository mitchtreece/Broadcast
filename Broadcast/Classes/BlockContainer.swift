//
//  BlockContainer.swift
//  Broadcast
//
//  Created by Mitch Treece on 5/4/18.
//

import Foundation

internal class BlockContainer {
    
    static let key = "BlockContainer.key"
    private(set) var block: ((Any)->())?
    
    init(block: @escaping (Any)->()) {
        self.block = block
    }
    
}
