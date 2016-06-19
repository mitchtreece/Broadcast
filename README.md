# Broadcast
Lightweight instance syncing & property binding.

[![CI Status](http://img.shields.io/travis/Mitch Treece/Broadcast.svg?style=flat)](https://travis-ci.org/Mitch Treece/Broadcast)
[![Version](https://img.shields.io/cocoapods/v/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)
[![License](https://img.shields.io/cocoapods/l/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)
[![Platform](https://img.shields.io/cocoapods/p/Broadcast.svg?style=flat)](http://cocoapods.org/pods/Broadcast)

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

## Syncable & Reactable
The `Syncable` and `Reactable` protocols are the bread-and-butter of Broadcast.

### Syncable
Objects conforming to `Syncable` will notify all instances of itself when property changes
occur. To conform to `Syncable`, an object simply needs to return a sync identifier, and call
`makeSyncable()` upon initialization.

```swift
class Post: Syncable {

    var postId: String
    var numberOfLikes: Int

    var syncId: String {
        return postId
    }

    init(postId: String, numberOfLikes: Int) {
        self.postId = postId
        self.numberOfLikes = numberOfLikes
        makeSyncable()
    }

}
```

Now, any property changes made inside a sync block will be propagated to all instances of an object
that share the same sync identifier.

```swift
let post = Post(postId: "post_0", numberOfLikes: 3)
post.sync { syncable in
    guard let post = syncable as? Post else { return }
    post.numberOfLikes += 1
}
```

### Reactable
Objects conforming to `Reactable` can be externally observed for property changes. Like `Syncable`, all you need to do is return
a react identifier.

```swift
class Post: Syncable, Reactable {

    var postId: String
    var numberOfLikes: Int

    var syncId: String {
        return postId
    }

    var reactId: String {
        return postId
    }

    init(postId: String, numberOfLikes: Int) {
        self.postId = postId
        self.numberOfLikes = numberOfLikes
        makeSyncable()
    }

}
```

Now property changes can be observed, and reacted upon! This is especially useful when binding UI elements to an object's state.

```swift
class PostCell: UITableViewCell {

    private var reactObserver: ReactObserver?

    var post: Post? {
        didSet {

            if let post = post {
                layoutUI(with: post)
                reactObserver = post.react { notification in
                    updateUI(with: post)
                }
            }

        }
    }

    ...

}
```

### Dynamic
Often times your objects will be `Syncable` & `Reactable`. You could conform to each protocol individually, but implementing
a sync & react identifier can get repetitive. That's where the `Dynamic` protocol comes in. The `Dynamic` protocol is a composition
of `Syncable` & `Reactable`. Objects conforming to `Dynamic` just need to provide a dynamic identifier, the sync & react identifiers
will be automatically asigned for you. **You still need to call `makeSyncable()` upon an object's initialization**.

```swift
class Post: Dynamic {

    var postId: String
    var numberOfLikes: Int

    var dynamicId: String {
        return postId
    }

    init(postId: String, numberOfLikes: Int) {
        self.postId = postId
        self.numberOfLikes = numberOfLikes
        makeSyncable()
    }

}
```
