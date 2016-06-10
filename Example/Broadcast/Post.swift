//
//  Post.swift
//  Syncability
//
//  Created by Mitch Treece on 6/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Broadcast

class Post {
    
    var postId: String
    var text: String
    var numberOfLikes: Int
    
    init(postId: String, text: String, numberOfLikes: Int) {
        self.postId = postId
        self.text = text
        self.numberOfLikes = numberOfLikes
        makeSyncable()
    }
    
}

extension Post: Dynamic {
    
    var dynamicId: String {
        return postId
    }
    
}