![Broadcast](Resources/logo.png)

[![Version](https://img.shields.io/cocoapods/v/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)
![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)
![iOS](https://img.shields.io/badge/iOS-10,%2011-blue.svg)
[![License](https://img.shields.io/cocoapods/l/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)

**Note**: Objective-C support was dropped in version `2.0.0`. If it's required, please use version `1.4.0` or lower.

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
To conform to `Broadcastable`, an object simply needs to return a broadcast identifier, and call `broadcast.make()` when initialized.
This broadcast identifier will be used to identify matching instances and notify them of changes.

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
        self.broadcast.make()

    }

}
```

### Signaling
Any changes made inside a signal block will be propagated to all instances of an object that share the same identifier.

```swift
post.broadcast.signal { (_post) in
    _post.numberOfLikes += 1
}
```

### Listening
Objects conforming to `Broadcastable` can be externally observed for changes. This is extremely useful when you need to bind your UI to an object's properties.

```swift
class PostCell: UITableViewCell {

    var updateListener: Listener?

    var post: Post? {
        didSet {

            guard let post = post else { return }

            layoutUI(with: post)

            updateListener = post.broadcast.listen { [weak self] in
                self?.layoutUI(with: post)
            }

        }
    }

    ...

}
```
