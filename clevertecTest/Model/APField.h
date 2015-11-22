//
//  APTextField.h
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APField : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *type;

@property (nonatomic) NSString *selectedValueKey;

@property (nonatomic) NSDictionary  *values;

@end
