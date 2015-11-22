//
//  Network.h
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APMetaData.h"
#import "AFNetworking.h"

@interface APNetwork : NSObject

@property (nonatomic) APMetaData *metaData;

//singlton иницилизация
+(APNetwork*) network;

- (void)getMetaData:(void(^)(APMetaData *data))successBlock failure:(void (^)(NSError *error))failureBlock;

- (void)cancleAllRequests;

- (void)sendData:(NSDictionary *)data success:(void (^)(NSString *result))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
