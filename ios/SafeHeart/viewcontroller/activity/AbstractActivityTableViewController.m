//
//  AbstractActivityTableViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-22.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "AbstractActivityTableViewController.h"
#import "ActivityCellView.h"
#import "Colors.h"
#import "Activity.h"
#import "MetricView.h"
#import "ViewUtil.h"
#import "StoryBoardController.h"
#import "InActivityViewController.h"

@interface AbstractActivityTableViewController ()

@end

@implementation AbstractActivityTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView registerNib:[UINib nibWithNibName:@"ActivityCellView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellActivity"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellActivity";
    ActivityCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCellView" owner:self options:nil] objectAtIndex:0];
    }
    
    [cell clearSubviews];
    
    Activity* a = [self.activities objectAtIndex:indexPath.row];
    
    cell.labelActivityName.text = [a name];
    
    MetricView* o2metric = [MetricView getViewForMetric:MetricOxygen];
    [o2metric setMetricValue:[a getOxygenLevelString]];
    
    MetricView* intensityMetric = [MetricView getViewForMetric:MetricIntensity];
    [intensityMetric setMetricValue:[a getIntensityLevelString]];
    
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [iv setImage:[UIImage imageNamed:@"light-green.png"]];
    
    [cell addAcessoryView:o2metric];
    [cell addAcessoryView:intensityMetric];

    return cell;    
}

int cellHeight;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellHeight == 0) {
        cellHeight = [(UITableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"ActivityCellView" owner:self options:nil] objectAtIndex:0] frame].size.height;
    }
    
    return cellHeight;
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    InActivityViewController* iavc = [storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierInActivityView]];
    [iavc setActivity:[self.activities objectAtIndex:indexPath.row]];
    [parentNavigationController pushViewController:iavc animated:YES];
}

-(void) setParentNavigationController:(UINavigationController*)n {
    NSLog(@"Setting parent navigation controller to %@",n);
    parentNavigationController = n;
}



@end
