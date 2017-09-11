//
//  BroadcastableObject.m
//  Pods
//
//  Created by Mitch Treece on 3/2/17.
//  Broadcast
//

#import "BroadcastableObject.h"
#import <Broadcast/Broadcast-Swift.h>

@interface BroadcastableObject ()
@property (nonatomic) NSString *broadcastId;
@property (nonatomic) BroadcastObserver *observer;
@end

@implementation BroadcastableObject

- (void)makeBroadcastableWithId:(NSString *)broadcastId {
    
    self.broadcastId = broadcastId;
    
    NSString *syncName = [NSString stringWithFormat:@"%@.synchronize", [self broadcastNotificationName]];
    
    __weak typeof(self) wSelf = self;
    
    self.observer = [[BroadcastObserver alloc] initWithName:syncName object:nil block:^(NSNotification * _Nonnull notif) {
        
        NSDictionary *info = [notif userInfo];
        BroadcastBlockContainer *container = info[BroadcastBlockContainer.key];
        
        if (container.block_objc) {
            container.block_objc(wSelf);
            NSString *updateName = [NSString stringWithFormat:@"%@.update", [wSelf broadcastNotificationName]];
            [[NSNotificationCenter defaultCenter] postNotificationName:updateName object:wSelf userInfo:nil];
        }
        
    }];
        
}

- (void)synchronize:(BroadcastBlock)block {
    
    BroadcastBlockContainer *container = [[BroadcastBlockContainer alloc] initWithBlock_objc:block];
    NSDictionary *info = @{BroadcastBlockContainer.key: container};
    NSString *name = [NSString stringWithFormat:@"%@.synchronize", [self broadcastNotificationName]];
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:info];
    
}

- (BroadcastObserver *)update:(BroadcastUpdateBlock)block {
    
    NSString *name = [NSString stringWithFormat:@"%@.update", [self broadcastNotificationName]];
    return [[BroadcastObserver alloc] initWithName:name object:self block:block];
    
}

- (NSString *)broadcastNotificationName {
    
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), self.broadcastId];
    
}

@end
