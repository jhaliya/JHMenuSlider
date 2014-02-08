//
//  JHRootViewController.m
//  JHMenuSlider
//
//  Created by Praveen Sharma on 08/02/14.
//  Copyright (c) 2014 Jhaliya. All rights reserved.
//

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
  CGPoint lastPoint;
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
  NSLog(@"Right swipe gesture");
  
  if(currentView == centerController.view) {
    [self leftRootButtonBarEvent:nil];
  } else if(currentView == rightController.view) {
    [self rightRootButtonBarEvent:nil];
  }
  
}

-(void) loadView {
  [super loadView];
  
  self.title = @"Root controller";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leftRootButtonBarEvent:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightRootButtonBarEvent:)];
}

-(void) rightRootButtonBarEvent:(id)sender {
  
  CGRect rRect;
  CGRect centerRect;
  
  if(currentView == centerController.view) {
    currentView = rightController.view;
    rRect = CGRectMake(KREVEAL_GAP, 0, self.view.frame.size.width,
                       self.view.frame.size.height);
    centerRect = CGRectMake(-KSCREEN_WIDTH + KREVEAL_GAP, 0, self.view.frame.size.width,
                            self.view.frame.size.height);
  } else {
    currentView = centerController.view;
    rRect = CGRectMake(KSCREEN_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    centerRect  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  
  [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1
                      options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        rightController.view.frame = rRect ;
                        centerController.view.frame = centerRect;
                        self.navigationController.navigationBar.frame = CGRectMake(centerRect.origin.x, 20, KSCREEN_WIDTH, 44);
                      } completion:^(BOOL finished) {
                        
                      }];
}

-(void) leftRootButtonBarEvent:(id)sender {
  
  CGRect leftRect;
  CGRect centerRect;
  
  if(currentView == centerController.view) {
    currentView = leftController.view;
    leftRect = CGRectMake(0, 0, self.view.frame.size.width - KREVEAL_GAP, self.view.frame.size.height);
    centerRect = CGRectMake(KSCREEN_WIDTH - KREVEAL_GAP, 0, self.view.frame.size.width - KREVEAL_GAP,
                            self.view.frame.size.height);
  } else {
    currentView = centerController.view;
    leftRect = CGRectMake(-KSCREEN_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    centerRect  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  
  [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1
                      options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        leftController.view.frame = leftRect ;
                        centerController.view.frame = centerRect;
                        self.navigationController.navigationBar.frame = CGRectMake(centerRect.origin.x, 20, KSCREEN_WIDTH, 44);
                      } completion:^(BOOL finished) {
                        
                      }];
  
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
