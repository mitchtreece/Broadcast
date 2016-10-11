//
//  ViewController.swift
//  Syncability
//
//  Created by Mitch Treece on 06/07/2016.
//  Copyright (c) 2016 Mitch Treece. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = [
        Post(postId: "0", text: "This is a post! w00t w00t!", numberOfLikes: 0),
        Post(postId: "1", text: "Hello, world!", numberOfLikes: 0),
        Post(postId: "2", text: "This post is really long. It just keeps going and going and going and going. Amazing! 😎", numberOfLikes: 0),
        Post(postId: "3", text: "blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah ", numberOfLikes: 0),
        Post(postId: "4", text: "Come with me if you want to live.", numberOfLikes: 0),
        Post(postId: "5", text: "🤑🤑🤑🤑🤑👻👻👻👻👻😨😨😨😨😨", numberOfLikes: 0),
        Post(postId: "6", text: "All your bases are belonging to us.", numberOfLikes: 0),
        Post(postId: "7", text: "Hello from the other sideeeeeeeeee", numberOfLikes: 0),
        Post(postId: "8", text: "Yay everything is up-to-date! How magical! 🎩", numberOfLikes: 0),
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func pushButtonTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.posts = self.posts
        navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[(indexPath as NSIndexPath).row]
        cell.post = post
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let post = posts[(indexPath as NSIndexPath).row]
        
        post.sync { (syncable) in
            guard let post = syncable as? Post else { return }
            post.numberOfLikes += 1
        }
        
    }
    
}

