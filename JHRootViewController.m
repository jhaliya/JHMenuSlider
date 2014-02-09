/*
 
 JHRootViewController.m
 JHMenuSlider
 
 Created by Praveen Sharma on 08/02/14.
 Copyright (c) 2014 Jhaliya. All rights reserved.
 
 The MIT License (MIT)
 
 Copyright (c) 2014 Praveen Sharma
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "JHRootViewController.h"
#import "JHLeftViewController.h"
#import "JHCenterViewController.h"
#import "JHRightViewController.h"
#import "JHConstant.h"

@implementation JHRootViewController {
  JHLeftViewController *leftController;
  JHCenterViewController *centerController;
  JHRightViewController *rightController;
  UIView *currentView;
}

+ (UIImage *) navigationButtonImage {
	static UIImage *naviImage = nil;
	static dispatch_once_t onceToken;
  
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 13.f), NO, 0.0f);
		
		[[UIColor greenColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 5, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 20, 1)] fill];
		
		[[UIColor yellowColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 6,  20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 20, 2)] fill];
		
		naviImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    
	});
  return naviImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    leftController = [[JHLeftViewController alloc] initWithNibName:nil bundle:nil];
    centerController = [[JHCenterViewController alloc] initWithNibName:nil bundle:nil];
    rightController = [[JHRightViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.view addSubview:leftController.view];
    [self.view addSubview:centerController.view];
    [self.view addSubview:rightController.view];
    
    currentView = centerController.view;
  }
  return self;
}

-(void)viewWillAppear:(BOOL)animated  {
  [super viewWillAppear:animated];
  
  centerController.view.frame = self.view.frame;
  leftController.view.frame =  CGRectMake(-KSCREEN_WIDTH, 0, self.view.frame.size.width,
                                          self.view.frame.size.height);
  rightController.view.frame =  CGRectMake(KSCREEN_WIDTH, 0, self.view.frame.size.width,
                                           self.view.frame.size.height);
  
  UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
  swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:swipeleft];

  UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
  swiperight.direction=UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:swiperight];
  
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer {
  if(currentView == centerController.view) {
    [self rightRootButtonBarEvent:nil];
  } else if(currentView == leftController.view) {
    [self leftRootButtonBarEvent:nil];
  }
  NSLog(@"Left swipe gesture");
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer {
  if(currentView == centerController.view) {
    [self leftRootButtonBarEvent:nil];
  } else if(currentView == rightController.view) {
    [self rightRootButtonBarEvent:nil];
  }
  NSLog(@"Right swipe gesture");
}


-(void) loadView {
  [super loadView];
  self.title = @"Root controller";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[self class] navigationButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(leftRootButtonBarEvent:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[self class] navigationButtonImage] style:UIBarButtonItemStylePlain target:self action:@selector(rightRootButtonBarEvent:)];
}

-(void) rightRootButtonBarEvent:(__unused id)sender {
  
  CGRect rRect;
  CGRect cRect;
  
  if(currentView == centerController.view) {
    currentView = rightController.view;
    rRect = CGRectMake(KREVEAL_GAP, 0, self.view.frame.size.width,
                       self.view.frame.size.height);
    cRect = CGRectMake(-KSCREEN_WIDTH + KREVEAL_GAP, 0, self.view.frame.size.width,
                            self.view.frame.size.height);
  } else {
    currentView = centerController.view;
    rRect = CGRectMake(KSCREEN_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    cRect  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  
  [UIView animateWithDuration:KANIMATION_TIME delay:KANIMATION_DELAY usingSpringWithDamping:KSPRING_WITH_DAMPING
        initialSpringVelocity:KINITIAL_SPRING_VALOCITY options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                        rightController.view.frame = rRect ;
                        centerController.view.frame = cRect;
                        self.navigationController.navigationBar.frame = CGRectMake(cRect.origin.x, KNAVIGATION_BAR_Y, KSCREEN_WIDTH, KNAVIGATION_BAR_HEIGHT);
                      } completion:nil];
}

-(void) leftRootButtonBarEvent:(id)sender {
  
  CGRect lRect;
  CGRect cRect;
  
  if(currentView == centerController.view) {
    currentView = leftController.view;
    lRect = CGRectMake(0, 0, self.view.frame.size.width - KREVEAL_GAP, self.view.frame.size.height);
    cRect = CGRectMake(KSCREEN_WIDTH - KREVEAL_GAP, 0, self.view.frame.size.width - KREVEAL_GAP,
                            self.view.frame.size.height);
  } else {
    currentView = centerController.view;
    lRect = CGRectMake(-KSCREEN_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    cRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  
  [UIView animateWithDuration:KANIMATION_TIME delay:KANIMATION_DELAY usingSpringWithDamping:KSPRING_WITH_DAMPING
        initialSpringVelocity:KINITIAL_SPRING_VALOCITY options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                        leftController.view.frame = lRect ;
                        centerController.view.frame = cRect;
                        self.navigationController.navigationBar.frame = CGRectMake(cRect.origin.x, KNAVIGATION_BAR_Y, KSCREEN_WIDTH, KNAVIGATION_BAR_HEIGHT);
                      } completion:nil];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
