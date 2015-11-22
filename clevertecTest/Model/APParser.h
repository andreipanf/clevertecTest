//
//  Parser.h
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APMetaData.h"

@interface APParser : NSObject

- (APMetaData *)parseMetaData:(NSData*)data;

@end
