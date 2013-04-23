//
//  LoginEntryViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "LoginEntryViewController.h"
#import "LoginViewController.h"

@interface LoginEntryViewController ()

@end

@implementation LoginEntryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[self tableView] setBackgroundColor:[UIColor clearColor]];
    if ([self.tableView respondsToSelector:@selector(setBackgroundView:)]) {
        [self.tableView setBackgroundView:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if( cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    if (indexPath.row == 0) {
        _loginId = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        _loginId .placeholder = @"Email";
        _loginId .autocorrectionType = UITextAutocorrectionTypeNo;
        _loginId.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [_loginId setClearButtonMode:UITextFieldViewModeWhileEditing];
        cell.accessoryView = _loginId ;
    }
    if (indexPath.row == 1) {
        _password = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        _password.placeholder = @"Password";
        _password.secureTextEntry = YES;
        _password.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _password.autocorrectionType = UITextAutocorrectionTypeNo;
        [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
        _password.returnKeyType = UIReturnKeyGo;
        cell.accessoryView = _password;
    }
    _password.delegate = self;
    _loginId.delegate = self;
    
    //[tableView1 addSubview:loginId];
    //[tableView1 addSubview:password];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [(LoginViewController *)self.parentViewController showTouchScreen:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [(LoginViewController *)self.parentViewController showTouchScreen:NO];
    
    if (textField == _password) {
        [(LoginViewController *)self.parentViewController tryLogin];
    }
    
    return YES;
}

#pragma mark - Public Methods

- (void)dismissKeyboard {
    [_password resignFirstResponder];
    [_loginId resignFirstResponder];
}

@end
