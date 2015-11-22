//
//  Network.m
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import "APParser.h"

@implementation APNetwork
{
    AFHTTPRequestOperationManager *manager;
}

+(APNetwork *) network {
    static APNetwork *network = nil;
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        network = [[self alloc] init];
    });
    return network;
    
}

- (void)getMetaData:(void(^)(APMetaData *data))successBlock failure:(void (^)(NSError *error))failureBlock
{
    manager = [ AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer =  [AFHTTPResponseSerializer serializer];
    
    [manager POST:CL_META_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        APParser *parser = [[APParser alloc]init];
        _metaData = [parser parseMetaData:responseObject];
        
        successBlock(self.metaData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
}

- (void)cancleAllRequests
{
    for (NSOperation *operation in manager.operationQueue.operations) {
        [operation cancel];
    }
    
    [manager.operationQueue cancelAllOperations];
}


- (void)sendData:(NSDictionary *)data success:(void (^)(NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *form = [NSDictionary dictionaryWithObject:data forKey:@"form"];

    [manager POST:CL_SEND_DATA_URL parameters:form
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *resultString = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]mutableCopy];
        successBlock(resultString);
        
    }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         failureBlock(error);
     }];
}

@end
