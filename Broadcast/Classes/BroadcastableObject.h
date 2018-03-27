//
//  BroadcastableObject.h
//  Pods
//
//  Created by Mitch Treece on 3/2/17.
//  Broadcast
//

#import <Foundation/Foundation.h>

@class BroadcastableObject;
@class BroadcastObserver;

typedef void (^BroadcastBlock)(BroadcastableObject * _Nonnull broadcastable);
typedef void (^BroadcastUpdateBlock)(NSNotification * _Nonnull notification);

@interface BroadcastableObject : NSObject

@property (nonatomic, readonly, nonnull) NSString *broadcastId;
@property (nonatomic, nullable) NSString *broadcastName;

- (void)makeBroadcastableWithId:(NSString * _Nonnull)broadcastId;
- (void)synchronize:(BroadcastBlock _Nonnull)block;
- (BroadcastObserver * _Nonnull)update:(BroadcastUpdateBlock _Nonnull)block;

@end
