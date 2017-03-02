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
    
    private var updateObserver: BroadcastObserver?
    
    var post: Post? {
        didSet {
            
            guard let post = post else { return }
            
            layout(with: post)
            updateObserver = post.update { [weak self] (notification) in
                self?.updateUI(with: post)
            }
            
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.selectionStyle = .none
        
        cellContentView.layer.cornerRadius = 4
        cellContentView.layer.masksToBounds = true
        
    }
    
    private func layout(with post: Post) {
        
        updateUI(with: post)
        
    }
    
    private func updateUI(with post: Post) {
        
        identifierLabel.text = "id: \(post.postId)"
        postTextLabel.text = post.text
        likesLabel.text = "❤️: \(post.numberOfLikes)"
        
    }
    
}
