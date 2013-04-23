//
//  ActivitiesViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-22.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "ActivityCategoryCollectionViewCell.h"
#import "iCarousel.h"
#import "BebasNeueLabel.h"
#import "Fonts.h"
#import "Colors.h"

@interface ActivitiesViewController ()

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *tableViewControllers;

@end

@implementation ActivitiesViewController

@synthesize carousel;
@synthesize items;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.items = [[NSMutableArray alloc] initWithObjects:@"Recommended",@"Recent",@"All",nil];
        self.tableViewControllers = [[NSMutableArray alloc] initWithCapacity:[self.items count]];
        
        _recommendedVc = [[AbstractActivityTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        _recentVc = [[AbstractActivityTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        _allVc = [[AbstractActivityTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        [self.tableViewControllers addObject:_recommendedVc];
        [self.tableViewControllers addObject:_recentVc];
        [self.tableViewControllers addObject:_allVc];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    carousel.type = iCarouselTypeLinear;
    carousel.decelerationRate = 0.8;
    
    [self carouselCurrentItemIndexDidChange:carousel];
    
    [[UserActivityManager sharedInstance] setDelegate:self];
    
    [[UserActivityManager sharedInstance] getActivityForType:ActivityTypeAll];
    [[UserActivityManager sharedInstance] getActivityForType:ActivityTypeRecent];
    [[UserActivityManager sharedInstance] getActivityForType:ActivityTypeRecommended];
    
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
}

- (UIView *)carousel:(iCarousel *)c viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150/*carousel.frame.size.width*/, c.frame.size.height)];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.textColor = [Colors getDarkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [Fonts getBebasNeueOfSize:30];
        label.tag = 1;
        
        CGFloat s = 7.0f;
        UIView *triangle = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width/2-s/2, view.frame.size.height-s/2, s, s)];
        triangle.backgroundColor = [Colors getDeepRedColor];
        triangle.transform = CGAffineTransformMakeRotation(M_PI * 45 / 180.0);
        
        [view addSubview:label];
        [view addSubview:triangle];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [items objectAtIndex:index];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    } else if (option == iCarouselOptionWrap) {
        return YES;
    }
    
    return value;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)c {
    
    AbstractActivityTableViewController* vc = [self.tableViewControllers objectAtIndex:c.currentItemIndex];
    [vc setParentNavigationController:self.navigationController];
    tableView.delegate = vc;
    tableView.dataSource = vc;
    [tableView reloadData];
}

#pragma mark - UserActivityManagerDelegate Methods

- (void)activityFetchedForType:(ActivityType)type array:(NSArray *)array {
    [self setActivity:array forType:type];
}

- (void)activityFecthFailForType:(ActivityType)type oldArray:(NSArray *)array error:(NSError *)error {
    [self setActivity:array forType:type];
}

#pragma mark - UserActivityManagerDelegate Helper Methods

- (void)setActivity:(NSArray *)activity forType:(ActivityType)type {
    
    if (type == ActivityTypeAll) {
        [_allVc setActivities:activity];
    } else if (type == ActivityTypeRecommended) {
        [_recommendedVc setActivities:activity];
    } else {
        [_recentVc setActivities:activity];
    }

    [tableView reloadData];
}


@end
