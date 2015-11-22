//
//  MainViewController.m
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import "MainViewController.h"

#import "DinamicTableViewController.h"

@interface MainViewController ()
{
    APMetaData *metaData;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)getMetaButtonPressed:(id)sender
{
    
    UIAlertController *alert = [self showLoading];
    [[APNetwork network] getMetaData:^(APMetaData *data){
        metaData = data;
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"ShowDinamicTableSegue" sender:self];
    }failure:^(NSError *error) {
        [alert dismissViewControllerAnimated:YES completion:^{
            if (error.code != -999) {
                NSString *localazedDescription = error.localizedDescription;
                [self showAlertWithTitle:@"Ошибка" andMessage:localazedDescription];
            }
        }];
    }];
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Отменить"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: nil];
    [alertView addAction: alertAction];
    [self presentViewController:alertView animated: YES completion: nil];
}


-(UIAlertController*)showLoading
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Загрузка данных\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loader.center = CGPointMake(130.5, 65.5);
    loader.color = [UIColor blackColor];
    [loader startAnimating];
    [alertView.view addSubview:loader];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Отменить"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: ^(UIAlertAction *action) {
                                                            [[APNetwork network] cancleAllRequests];
                                                            
                                                            NSLog(@"Dismiss button tapped!");
                                                        }];
    
    [alertView addAction: alertAction];
    
    [self presentViewController:alertView animated: YES completion: nil];
    
    return alertView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setMetaData:metaData];
}



@end
