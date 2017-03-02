# Broadcast
Lightweight instance syncing & property binding.

[![Version](https://img.shields.io/cocoapods/v/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)
![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)
[![License](https://img.shields.io/cocoapods/l/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)

## Overview
Broadcast is a quick-and-dirty solution for instance syncing and property binding. Similar things can be achieved with libraries
like [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa), but these are often overly-complicated and more robust than needed.

## Installation
### CocoaPods
Broadcast is integrated with CocoaPods!

1. Add the following to your `Podfile`:
```
use_frameworks!
pod 'Broadcast'
```
2. In your project directory, run `pod install`
3. Import the `Broadcast` module wherever you need it
4. Profit

### Manually
You can also manually add the source files to your project.

1. Clone this git repo
2. Add all the Swift files in the `Broadcast/` subdirectory to your project
3. Profit

## Broadcastable
The `Broadcastable` protocol defines an object that can notify and react when property changes occur.
To conform to `Broadcastable`, an object simply needs to return a broadcast identifier, and call `makeBroadcastable` when initialized.
This identifier broadcast identifier will be used to identify matching instances and notify them of changes.

```swift
class Post: Broadcastable {

    var postId: String
    var numberOfLikes: Int

    var broadcastId: String {
        return postId
    }

    init(postId: String, numberOfLikes: Int) {
        self.postId = postId
        self.numberOfLikes = numberOfLikes
        makeBroadcastable()
    }

}
```

### Synchronization
Any changes made inside a synchronization block will be propagated to all instances of an object that share the same broadcast identifier.

```swift
post.synchronize { (broadcastable) in
    guard let _post = broadcastable as? Post else { return }
    _post.numberOfLikes += 1
}
```

### Observation
Objects conforming to `Broadcastable` can be externally observed for changes. This is extremely useful when you need to bind your UI to an object's properties.

```swift
class PostCell: UITableViewCell {

    private var updateObserver: BroadcastObserver?

    var post: Post? {
        didSet {

            guard let post = post else { return }

            layoutUI(with: post)
            updateObserver = post.update { [weak self] (notification) in
                self?.updateUI(with: post)
            }

        }
    }

    ...

}
```

### BroadcastObserver
The `BroadcastObserver` class is a simple block-based wrapper over `NotificationCenter` observation. It automatically handles observer removal on de-initialization.

### Objective-C
For those of you refusing to embrace the future, the latest release of Broadcast now has Objective-C compatibility. Broadcast relies heavily on Swift's awesome protocol features, some of which Objective-C doesn't support. Because of this, classes in Objective-C will need to inherit from the `BroadcastableObject` class instead of conforming to the `Broadcastable` protocol. Other than that, working with Broadcast should be the same.
