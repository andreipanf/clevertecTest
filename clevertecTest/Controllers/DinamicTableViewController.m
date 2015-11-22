//
//  DinamicTableViewController.m
//  clevertecTest
//
//  Created by Andrey on 22.11.15.
//  Copyright © 2015 Andrey. All rights reserved.
//

#import "DinamicTableViewController.h"
#import "APField.h"

@interface DinamicTableViewController () <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITextField *currentString;
    NSMutableDictionary *dataForSend;
}
@end

@implementation DinamicTableViewController

@synthesize metaData;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleLabel];
}

-(void)setTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [NSString stringWithFormat:@"%@",metaData.title];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

-(UIToolbar*)setupNumberToolbar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Готово" style:UIBarButtonItemStyleDone target:self action:@selector(doneToolbarButtonPressed)]];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

-(UIToolbar*)setupPickerToolbar
{
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:
                            CGRectMake(0,0, 320, 44)];
    myToolbar.barStyle = UIBarStyleDefault;
    myToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Готово" style:UIBarButtonItemStyleDone target:self action:@selector(doneToolbarButtonPressed)]];
    return myToolbar;
}

-(void)doneToolbarButtonPressed{
    
    [currentString resignFirstResponder];
}

-(NSIndexPath*)getIndexPathForTextField:(UITextField*)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    return indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        [textField resignFirstResponder];
    }
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentString =textField;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [self getIndexPathForTextField:textField];
    APField *field = [metaData.fields objectAtIndex:indexPath.row];
    
    if (dataForSend == nil) {
        dataForSend = [[NSMutableDictionary alloc]init];
    }
    
    if ([field.type isEqualToString:@"LIST"]) {
        if (textField.text.length > 0) {
            NSString *key = [[field.values allKeysForObject:textField.text]lastObject];
            [dataForSend setObject:key forKey:field.name];
        }
    }else{
        [dataForSend setObject:textField.text forKey:field.name];
    }
}



#pragma mark - UIPickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSIndexPath *indexPath = [self getIndexPathForTextField:currentString];
    APField *field = [metaData.fields objectAtIndex:indexPath.row];
    
    if ([field.values count] > 0) {
        return [field.values count];
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSArray *titles = [self getArrayOfTitlesFromTextField:currentString];
    
    NSString *title = titles[row];
    if (title.length > 0) {
        return title;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *titles = [self getArrayOfTitlesFromTextField:currentString];
    currentString.text = titles[row];
}

-(NSArray*)getArrayOfTitlesFromTextField:(UITextField*)textField
{
    NSIndexPath *indexPath = [self getIndexPathForTextField:textField];
    APField *field = [metaData.fields objectAtIndex:indexPath.row];
    
    NSArray *sortedKeys = [field.values.allKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
    
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    
    for (NSString *key in sortedKeys) {
        [titles addObject:[field.values objectForKey:key]];
    }
    return titles;
}

#pragma mark - Table view

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    APField *field = [metaData.fields objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
    nameLabel.text = field.title;
    
    UITextField *textField = (UITextField *)[cell viewWithTag:102];
    textField.delegate = self;
    
    if ([field.type isEqualToString:@"NUMERIC"]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        
        UIToolbar* numberToolbar = [self setupNumberToolbar];
        textField.inputAccessoryView = numberToolbar;
    }else if ([field.type isEqualToString:@"LIST"]){
        UIPickerView *pickerView = [[UIPickerView alloc]init];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        textField.inputView = pickerView;
        
        UIToolbar *pickerToolbar = [self setupPickerToolbar];
        
        textField.inputAccessoryView = pickerToolbar;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return metaData.fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FieldCell" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}




- (IBAction)sendButtonPressed:(id)sender {
    if (currentString.text) {
        [currentString resignFirstResponder];
    }
    if (dataForSend !=nil) {
        UIAlertController *alert = [self showLoading];
        [[APNetwork network]sendData:dataForSend success:^(NSString *result){
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self showAlertWithTitle:@"Отправлено" andMessage:result];
        }failure:^(NSError *error){
            [alert dismissViewControllerAnimated:YES completion:^{
                if (error.code != -999) {
                    NSString *localazedDescription = error.localizedDescription;
                    [self showAlertWithTitle:@"Ошибка" andMessage:localazedDescription];
                }
            }];
        }];
    }else{
       [self showAlertWithTitle:@"Ошибка" andMessage:@"Нет данных для отпраки"];
    }
    
    
    
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

@end
