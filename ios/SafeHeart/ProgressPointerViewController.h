//
//  ViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-14.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ProgressClassifier.h"

@interface ProgressPointerViewController : UIViewController {
    int min;
    int max;
    BOOL showPercentage;
    BOOL isProgressive;
    CAGradientLayer *gradient;
    double currentProgress;
    id<ProgressClassifier> classifier;
}

@property (strong, nonatomic) IBOutlet UIView *viewCurrentPositionIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *viewProgressContainer;
@property (strong, nonatomic) IBOutlet UIImageView *viewProgress;
@property (strong, nonatomic) IBOutlet UILabel *labelProgress;
@property (strong, nonatomic) IBOutlet UILabel *labelSubtext;
@property (strong, nonatomic) IBOutlet UILabel *labelMax;
@property (strong, nonatomic) IBOutlet UILabel *labelMin;


-(void) setProgress:(double)d;
-(void) setSubtext:(NSString*)s;
-(void) setProgressive:(BOOL)b;
-(void) setShowPercentage:(BOOL)b;
-(void) setRangeVisible:(BOOL)b;
-(void) setRangeWithMin:(int)minimum Max:(int)maximum;
-(void) setProgressClassifier:(id<ProgressClassifier>)c;

@end
