//
//  ViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-14.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ProgressPointerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NormalClassifier.h"

@interface ProgressPointerViewController ()

@end

@implementation ProgressPointerViewController

@synthesize labelSubtext,viewCurrentPositionIndicator,viewProgressContainer,viewProgress,labelProgress,labelMax,labelMin;

NSTimer* viewLoadedTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setProgressClassifier:[[NormalClassifier alloc] init]];
        
        // a hack which loops until the view dimensions are set (viewDidLoad not called when in a container)
        viewLoadedTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.

    showPercentage = true;
    isProgressive = false;
    
    min = 0;
    max = 100;    
}

-(void)viewDidAppear:(BOOL)animated {
    [self refresh];
}


- (IBAction)randomizeProgress:(id)sender {
    double d = (arc4random() % 101)/100.0;
    [self setProgress:d];
}



-(void) refresh {
    //NSLog(@"Now parent is %f x %f",self.viewProgressContainer.frame.size.width,self.viewProgressContainer.frame.size.height);

    if (self.viewProgressContainer.frame.size.width == 0) {
        return;
    } else {
        [viewLoadedTimer invalidate];
    }
    
    [self setStatus:currentProgress];    

    double correctedCurrentProgress = currentProgress;
    if (correctedCurrentProgress < min) { correctedCurrentProgress = min; }
    if (correctedCurrentProgress > max) { correctedCurrentProgress = max; }
    
    double percentage = (correctedCurrentProgress-min)/(max-min);
    
    //NSLog(@"Current progress is %f, Percentage is %f",currentProgress,percentage);
    
    if (isProgressive) { [viewProgress setHidden:NO]; }
    
    CGFloat parentHeight = viewProgressContainer.frame.size.height;
    //CGFloat parentWidth = viewProgressContainer.frame.size.width;
    
    
    CGFloat targetXposition = percentage*viewProgressContainer.frame.size.width + viewProgressContainer.frame.origin.x;
    
    CGRect rectCurrentProgressBar = viewProgress.frame;
    CGRect rectNewProgressBar = CGRectMake(rectCurrentProgressBar.origin.x, rectCurrentProgressBar.origin.y, targetXposition-rectCurrentProgressBar.origin.x, parentHeight);
    
    CGRect rectCurrentIndicator = viewCurrentPositionIndicator.frame;
    CGRect rectNewIndicator = CGRectMake(targetXposition-rectCurrentIndicator.size.width/2, rectCurrentIndicator.origin.y, rectCurrentIndicator.size.width, rectCurrentIndicator.size.height);
    
    //NSLog(@"New x is %f",rectNewIndicator.origin.x);
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         if (isProgressive) {
                             viewProgress.frame = rectNewProgressBar;
                         }
                         viewCurrentPositionIndicator.frame = rectNewIndicator;
                     }
                     completion:NULL];
    
    if (!isProgressive) {
        [viewProgress setHidden:YES];
        
        if (gradient != nil) {
            [gradient removeFromSuperlayer];
        }
        
        gradient = [CAGradientLayer layer];
        gradient.frame = viewProgressContainer.bounds;
        
        gradient.colors = [NSArray arrayWithObjects:(id)[rgb(6, 186, 237) CGColor], (id)[rgb(88, 253, 10) CGColor],(id)[rgb(238, 236, 0) CGColor],(id)[rgb(199, 15, 1) CGColor], nil];
        //NSLog(@"(%f,%f) -> (%f,%f)",[gradient startPoint].x,[gradient startPoint].y,[gradient endPoint].x,[gradient endPoint].y);
        [gradient setStartPoint:CGPointMake(0,0.5)];
        [gradient setEndPoint:CGPointMake(1,0.5)];
        
        [viewProgressContainer.layer insertSublayer:gradient atIndex:0];
    }
}

-(void) setProgress:(double)d {
    currentProgress = d;
    [self refresh];
}

UIColor* rgb(int r, int g, int b) {
    return [[UIColor alloc] initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

-(void) setStatus:(double) d {
    [labelProgress setText:[classifier classifyProgress:d]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setSubtext:(NSString*)s {
    [labelSubtext setText:s];
}

-(void) setProgressive:(BOOL)b {
    isProgressive = b;
    [self refresh];
}

-(void) setRangeWithMin:(int)minimum Max:(int)maximum {
    min = minimum;
    max = maximum;
    
    //NSLog(@"Setting min/max text");
    [labelMin setText:[NSString stringWithFormat:@"%i",min]];
    [labelMax setText:[NSString stringWithFormat:@"%i",max]];
}

-(void) setRangeVisible:(BOOL)b {
    [labelMax setHidden:!b];
    [labelMin setHidden:!b];
}

-(void) setShowPercentage:(BOOL)b {
    showPercentage = b;
}

-(void) setProgressClassifier:(id<ProgressClassifier>)c {
    classifier = c;
}

@end
