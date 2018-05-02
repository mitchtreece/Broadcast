//
//  DataManager.swift
//  Broadcast
//
//  Created by Mitch Treece on 2/22/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private(set) var posts: [Post] = [
        Post(postId: "0", text: "This is a post! w00t w00t!", numberOfLikes: 0),
        Post(postId: "1", text: "Hello, world!", numberOfLikes: 0),
        Post(postId: "2", text: "This post is really long. It just keeps going and going and going and going. Amazing! 😎", numberOfLikes: 0),
        Post(postId: "3", text: "blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ", numberOfLikes: 0),
        Post(postId: "4", text: "Come with me if you want to live.", numberOfLikes: 0),
        Post(postId: "5", text: "🤑🤑🤑🤑🤑👻👻👻👻👻😨😨😨😨😨", numberOfLikes: 0),
        Post(postId: "6", text: "All your bases are belonging to us.", numberOfLikes: 0),
        Post(postId: "7", text: "Hello from the other sideeeeeeeeee", numberOfLikes: 0),
        Post(postId: "8", text: "Yay everything is up-to-date! How magical! 🎩", numberOfLikes: 0)
    ]
    
}
