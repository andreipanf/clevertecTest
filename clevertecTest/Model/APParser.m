//
//  Parser.m
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import "APParser.h"
#import "APField.h"

@implementation APParser

- (APMetaData *)parseMetaData:(NSData*)data
{
    //Костыль с добавление запятой
    NSMutableString *htmlString = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]mutableCopy];
    NSRange range = [htmlString rangeOfString:@"\"Динамическая форма\""];
    [htmlString replaceCharactersInRange:range withString:@"\"Динамическая форма\","];
    
    NSData *validData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    id json = [NSJSONSerialization JSONObjectWithData:validData options:0 error:nil];
    
    APMetaData *metaData = [[APMetaData alloc]init];
    metaData.title = json[@"title"];
    
    NSMutableArray *fields = [[NSMutableArray alloc]init];
    
    NSArray *jsonField = json[@"fields"];
    for (NSDictionary *field in jsonField) {
        APField *textField = [[APField alloc]init];
        textField.title = field[@"title"];
        textField.name  = field[@"name"];
        textField.type  = field[@"type"];
        
        
        
        if ([field[@"type"] isEqualToString:@"LIST"]) {
            textField.values = field[@"values"];
        }
        
        [fields addObject:textField];
    
    }
    
    metaData.fields = [NSArray arrayWithArray:fields];
    
    return metaData;
}

@end
