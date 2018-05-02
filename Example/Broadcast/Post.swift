//
//  Post.swift
//  Syncability
//
//  Created by Mitch Treece on 6/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Broadcast

class Post: Broadcastable {
    
    var postId: String
    var text: String
    var numberOfLikes: Int
    
    var broadcastId: String {
        return postId
    }
    
    init(postId: String, text: String, numberOfLikes: Int) {
        
        self.postId = postId
        self.text = text
        self.numberOfLikes = numberOfLikes
        makeBroadcastable()
        
    }
    
}
