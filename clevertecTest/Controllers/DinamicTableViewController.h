//
//  DinamicTableViewController.h
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APMetaData.h"

@interface DinamicTableViewController : UITableViewController

@property (nonatomic,strong) APMetaData *metaData;

- (IBAction)sendButtonPressed:(id)sender;

@end
