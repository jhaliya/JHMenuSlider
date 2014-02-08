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

@implementation JHRootViewController {
  JHLeftViewController *leftController;
  JHCenterViewController *centerController;
  JHRightViewController *rightController;

  UIView *currentView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

-(void)viewWillAppear:(BOOL)animated  {
  [super viewWillAppear:animated];
  centerController.view.frame = self.view.frame;
  leftController.view.frame =  CGRectMake(-320, 0, self.view.frame.size.width, self.view.frame.size.height);
  rightController.view.frame =  CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void) loadView {
  [super loadView];
  
  leftController = [[JHLeftViewController alloc] initWithNibName:nil bundle:nil];
  centerController = [[JHCenterViewController alloc] initWithNibName:nil bundle:nil];
  rightController = [[JHRightViewController alloc] initWithNibName:nil bundle:nil];
  
  self.title = @"Root controller";
  self.view.backgroundColor = [UIColor greenColor];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leftRootButtonBarEvent:)];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightRootButtonBarEvent:)];
  
  [self.view addSubview:leftController.view];
  [self.view addSubview:centerController.view];
  [self.view addSubview:rightController.view];
  
  currentView = centerController.view;
}

-(void) rightRootButtonBarEvent:(id)sender {
  
  NSLog(@"right button clicked");
  
  CGRect rRect;
  CGRect centerRect;
  
  if(currentView == centerController.view) {
    currentView = rightController.view;
    rRect = CGRectMake(50, 0, self.view.frame.size.width - 50, self.view.frame.size.height);
    centerRect = CGRectMake(-320+50, 0, self.view.frame.size.width - 50, self.view.frame.size.height);
    NSLog(@"Current view is center view");
  } else {
    currentView = centerController.view;
    rRect = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height);
    centerRect  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"Current view is left view");
  }
  
  
  NSLog(@"Rigth view moving to %@",NSStringFromCGRect(rRect));
  NSLog(@"center view moving from %@",NSStringFromCGRect(centerRect));
  /*
  [UIView animateWithDuration:2.0 delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        rightController.view.frame = rRect ;
                        centerController.view.frame = centerRect;
                        self.navigationController.navigationBar.frame = CGRectMake(centerRect.origin.x, 20, 320, 44);
                      } completion:^(BOOL finished) {
                        
                      }];
   
   */
  
  [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1
                      options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        rightController.view.frame = rRect ;
                        centerController.view.frame = centerRect;
                        self.navigationController.navigationBar.frame = CGRectMake(centerRect.origin.x, 20, 320, 44);
                      } completion:^(BOOL finished) {
                        
                      }];
}

-(void) leftRootButtonBarEvent:(id)sender {
  NSLog(@"Left button clicked");
  
  CGRect leftRect;
  CGRect centerRect;
  
  if(currentView == centerController.view) {
    currentView = leftController.view;
    leftRect = CGRectMake(0, 0, self.view.frame.size.width - 50, self.view.frame.size.height);
    centerRect = CGRectMake(320 - 50, 0, self.view.frame.size.width - 50, self.view.frame.size.height);
    NSLog(@"Current view is center view");
  } else {
    
    currentView = centerController.view;
    leftRect = CGRectMake(-320, 0, self.view.frame.size.width, self.view.frame.size.height);
    centerRect  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"Current view is left view");
  }
  
  
  NSLog(@"Left view moving to %@",NSStringFromCGRect(leftRect));
  NSLog(@"center view moving from %@",NSStringFromCGRect(centerRect));
  
  /*
  [UIView animateWithDuration:2.0 delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        
                        leftController.view.frame = leftRect ;
                        centerController.view.frame = centerRect;
                        self.navigationController.navigationBar.frame = CGRectMake(centerRect.origin.x, 20, 320, 44);
                        
                      } completion:^(BOOL finished) {
                        
                        
                      }];
   */
  
  [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1
                      options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        leftController.view.frame = leftRect ;
                        centerController.view.frame = centerRect;
                        self.navigationController.navigationBar.frame = CGRectMake(centerRect.origin.x, 20, 320, 44);
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
