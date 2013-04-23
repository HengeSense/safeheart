//
//  MenuViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "MenuViewController.h"
#import "StoryBoardController.h"
#import "MenuCell.h"
#import "LoginManager.h"
#import "ProfileViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

NSArray* options;

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
    
    options = [[NSArray alloc] initWithObjects:@"My Profile", @"My Clinician", @"Connect HR Monitor", @"Log Out", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [StoryBoardController identifierMenuCell];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.labelTitle setText:[options objectAtIndex:indexPath.row]];

    return cell;
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    
    switch(indexPath.row) {
        case 0:
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:pvc] animated:YES completion:nil];
            break;
        case 1:
            break;
        case 2:
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierConnectHRView]] animated:YES completion:nil];
            break;
        case 3:
            [[LoginManager sharedInstance] logOut];
            [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierLoginView]] animated:YES completion:nil];
            break;
    }
}

@end
