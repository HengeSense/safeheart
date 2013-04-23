//
//  RecentActivitiesViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "RecentActivitiesViewController.h"
#import "StoryBoardController.h"
#import "RecentActivityCell.h"
#import "Fonts.h"
#import "MetricView.h"
#import "ActivityCellView.h"
#import "SummaryViewController.h"
#import "RecentActivity.h"
#import "ActivityCompletionViewController.h"

@interface RecentActivitiesViewController ()

@end

@implementation RecentActivitiesViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UserActivityManager sharedInstance] setDelegate:self];
    [[UserActivityManager sharedInstance] getActivityForType:ActivityTypeRecent];
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
    return [_recentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cellActivity";
    ActivityCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //NSLog(@"Cell is nil");
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityCellView" owner:self options:nil] objectAtIndex:0];
        
    }
    [cell clearSubviews];
    
    RecentActivity *recentActivity = [_recentArray objectAtIndex:indexPath.row];
    
    cell.labelActivityName.text = recentActivity.name;
    
    MetricView* timeMetric = [MetricView getViewForMetric:MetricTime];
    [timeMetric setMetricValue:[MetricView encodeTimeWithMinutes:(int)(recentActivity.duration/60.0) seconds:(int)((int)recentActivity.duration%60)]];
    MetricView* heartMetric = [MetricView getViewForMetric:MetricHeart];
    [heartMetric setMetricValue:[NSString stringWithFormat:@"%d",(int)recentActivity.avgHeartRate]];
    [cell addAcessoryView:timeMetric];
    [cell addAcessoryView:heartMetric];    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Recent Activities";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 728, 40)];
    sectionView.backgroundColor = [[UIColor alloc] initWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(8,-3,300,30)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.font = [Fonts getBebasNeueOfSize:20.0];
    tempLabel.text= [self tableView:tableView titleForHeaderInSection:section];
    
    [sectionView addSubview:tempLabel];
    
    return sectionView;
}

int cellHeight;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cellHeight == 0) {
        cellHeight = [(UITableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"ActivityCellView" owner:self options:nil] objectAtIndex:0] frame].size.height;
    }
    
    return cellHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    RecentActivity *recentActity = [_recentArray objectAtIndex:indexPath.row];
    
    [[RequestManager sharedInstance] requestActivityLogForActivity:recentActity completion:^(NSDictionary *dictionary) {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        ActivityLog *log = [[ActivityLog alloc] initWithActivity:recentActity];
        log.startTime = [timeFormat dateFromString:recentActity.startTimeString];
        log.stopTime = [timeFormat dateFromString:recentActity.stopTimeString];
        NSArray *calorieArray = [dictionary objectForKey:@"calorieEvents"];
        NSArray *locationArray = [dictionary objectForKey:@"locationEvents"];
        NSArray *heartRateArray = [dictionary objectForKey:@"heartRateEvents"];
        [log setCalories:calorieArray];
        [log setLocation:locationArray];
        [log setHeartRate:heartRateArray];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ActivityCompletionViewController *acVc = [storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierCompletionView]];
        [acVc setActivityLog:log];
        [self.navigationController presentViewController:acVc animated:YES completion:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        }];
    }];
}

#pragma mark - UserActivityManagerDelegate Methods

- (void)activityFetchedForType:(ActivityType)type array:(NSArray *)array {
    if (type == ActivityTypeRecent) {
        _recentArray = array;
        [self.tableView reloadData];
    }
}

- (void)activityFecthFailForType:(ActivityType)type oldArray:(NSArray *)array error:(NSError *)error {
    if (type == ActivityTypeRecent) {
        _recentArray = array;
        [self.tableView reloadData];
    }
}

@end
