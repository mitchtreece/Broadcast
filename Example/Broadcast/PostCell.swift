//
//  PostCell.swift
//  Syncability
//
//  Created by Mitch Treece on 6/7/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Broadcast

class PostCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    private var reactObserver: ReactObserver?
    
    var post: Post? {
        didSet {
            
            if let post = post {
                updateUI(post)
                reactObserver = post.react { notification in
                    self.updateUI(post)
                }
            }

            
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.selectionStyle = .None
        
        cellContentView.layer.cornerRadius = 4
        cellContentView.layer.masksToBounds = true
        
    }
    
    private func updateUI(post: Post) {
        identifierLabel.text = "postId: \(post.postId)"
        postTextLabel.text = post.text
        likesLabel.text = "❤️: \(post.numberOfLikes)"
    }
    
}