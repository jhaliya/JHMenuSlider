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
#import "math.h"

typedef enum {
ELeftView,
ERootView,
ERightView,
ENoneView,
} JHCurrentView;

#define kMenuTransformScale CATransform3DMakeScale(0.85, 0.85, 0.85)
#define kMenuLayerInitialOpacity 0.4f

@implementation JHRootViewController {
  JHLeftViewController *leftController;
  JHCenterViewController *centerController;
  JHRightViewController *rightController;
  UIView *currentView;
  CGPoint lastGesturePoint;
  
  UITapGestureRecognizer *tapGestureRecognizer;
  UIPanGestureRecognizer *panGestureRecognizer;
  
  
   UIView *eventView;
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
    
    //Shadow effect
    //[self controllerShadow:leftController];
    //[self controllerShadow:centerController];
    //[self controllerShadow:rightController];
    
    currentView = centerController.view;
    
    lastGesturePoint  = CGPointMake(0, 0);
  }
  return self;
}

-(void) controllerShadow:(UIViewController* ) controller {
  
  // border
  [controller.view.layer setBorderColor:[UIColor clearColor].CGColor];
  [controller.view.layer setBorderWidth:1.5f];
  
  // drop shadow
  [controller.view.layer setShadowColor:[UIColor clearColor].CGColor];
  [controller.view.layer setShadowOpacity:0.7];
  [controller.view.layer setShadowRadius:10.0];
  [controller.view.layer setShadowOffset:CGSizeMake(5.0, 5.0)];
  
  /*
  controller.view.layer.masksToBounds = NO;
  controller.view.layer.shadowOffset = CGSizeMake(-5, 5);
  controller.view.layer.shadowRadius = 3;
  controller.view.layer.shadowOpacity = 0.5;
  */
}

-(void) displayRectPostion {
  NSLog(@"Left-->%@",NSStringFromCGRect(leftController.view.frame));
  NSLog(@"Root-->%@",NSStringFromCGRect(centerController.view.frame));
  NSLog(@"Right->%@",NSStringFromCGRect(rightController.view.frame));
}

-(JHCurrentView) currentViewState {
  if(currentView == leftController.view) {
    NSLog(@"It's left view");
    return ELeftView;
  } else if(currentView == centerController.view) {
    NSLog(@"It's root view");
    return ERootView;
  } else if(currentView == rightController.view) {
    NSLog(@"It's right view");
    return ERightView;
  }
  return ENoneView;
}

-(void)viewWillAppear:(BOOL)animated  {
  [super viewWillAppear:animated];
  
  centerController.view.frame = self.view.frame;
  leftController.view.frame =  CGRectMake(-KSCREEN_WIDTH, 0, self.view.frame.size.width,
                                          self.view.frame.size.height);
  rightController.view.frame =  CGRectMake(KSCREEN_WIDTH, 0, self.view.frame.size.width,
                                           self.view.frame.size.height);

  
  tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
  panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
  
  [tapGestureRecognizer addTarget:self action:@selector(handleTapGestureRecognizer:)];
  [panGestureRecognizer addTarget:self action:@selector(handlePanGestureRecognizer:)];
  
  eventView = [[UIView alloc] initWithFrame:self.view.bounds];
  eventView.backgroundColor = [UIColor clearColor];
  [eventView addGestureRecognizer:tapGestureRecognizer];
  [eventView addGestureRecognizer:panGestureRecognizer];
  
  [self.view addSubview:eventView];
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

//Support for the other orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  NSLog(@"willRotateToInterfaceOrientation %@", NSStringFromCGRect(self.view.frame));
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  NSLog(@"didRotateFromInterfaceOrientation %@", NSStringFromCGRect(self.view.frame));
  /*
   leftController.view.frame = ;
   centerController.view.frame = ;
   rightController.view.frame = ;
  */
}

#pragma mark - Gesture Recognizers -

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap {
  NSLog(@"handleTapGesture");
  
  if([self currentViewState] == ELeftView) {
    [self leftRootButtonBarEvent:nil];
  } else if([self currentViewState] == ERightView) {
    [self rightRootButtonBarEvent:nil];
  }
  
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
  
  JHCurrentView currentViewValue =  [self currentViewState];
  
  CGPoint translation = [gesture translationInView:currentView.superview];
  //NSLog(@"gesture points --> %@", NSStringFromCGPoint(translation));
  if(fabsf(translation.x) - fabsf(lastGesturePoint.x) > 0) {
    NSLog(@"point increasing ...");
  } else  {
    NSLog(@"point decereasing ...");
  }
  if([gesture state] == UIGestureRecognizerStateBegan) {
    NSLog(@"UIGestureRecognizerStateBegan");
  } else if([gesture state] == UIGestureRecognizerStateEnded) {
    
    if([self currentViewState] == ELeftView) {
    } else if([self currentViewState] == ERootView) {
      if((-leftController.view.frame.origin.x) < leftController.view.frame.size.width/2) {
        
        [UIView animateWithDuration:0.1f delay:KANIMATION_DELAY usingSpringWithDamping:KSPRING_WITH_DAMPING
              initialSpringVelocity:KINITIAL_SPRING_VALOCITY options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                           [self moveLeftCByX:0 width:leftController.view.frame.size.width-KREVEAL_GAP];
                           [self moveRootCByX:KSCREEN_WIDTH - KREVEAL_GAP];
                         } completion:nil];
      }
    } else if([self currentViewState] == ERightView) {
    }
    
    NSLog(@"UIGestureRecognizerStateEnded");
  } else if([gesture state] == UIGestureRecognizerStateChanged) {
    [self displayRectPostion];
    if(currentViewValue == ELeftView) {
      
      
    } else if(currentViewValue == ERootView) {
      CGFloat pointScale = translation.x * 1.5;
      if([self isMovingLeftDirection:translation.x]) {
        NSLog(@"Moving toward left ..");
        if(fabsf(leftController.view.frame.origin.x) > KREVEAL_GAP) {
          [self moveLeftCByX:pointScale-KSCREEN_WIDTH width:leftController.view.frame.size.width];
          [self moveRootCByX:pointScale];
        } else {
          currentView = leftController.view;
          [self moveLeftCByX:0 width:leftController.view.frame.size.width - KREVEAL_GAP];
          [self moveRootCByX:KSCREEN_WIDTH - KREVEAL_GAP];
        }
      } else if([self isMovingRightDirection:translation.x]) {
        NSLog(@"Moving toward right ..");
        if(centerController.view.frame.origin.x > 0) {
          NSLog(@"Revealing root view ...");
          [self moveLeftCByX:pointScale - KSCREEN_WIDTH width:leftController.view.frame.size.width];
          [self moveRootCByX:pointScale];
        } else {
          NSLog(@"Set view as Root view.. ");
          currentView = centerController.view;
          [self moveLeftCByX:-KSCREEN_WIDTH width:leftController.view.frame.size.width];
          [self moveRootCByX:0];
        }
      }
      
    } else if(currentViewValue == ERightView) {
      
    }
  }
  
  lastGesturePoint = translation;
}

-(BOOL) isMovingLeftDirection:(CGFloat) point {
  return ((fabsf(point) - fabsf(lastGesturePoint.x)) > 0);
}

-(BOOL) isMovingRightDirection:(CGFloat) point {
  return ((fabsf(point) - fabsf(lastGesturePoint.x)) < 0);
}

-(void) moveLeftCByX:(CGFloat) xPoint width:(CGFloat) width {
  leftController.view.frame = CGRectMake(xPoint, leftController.view.frame.origin.y,
                                         width, leftController.view.frame.size.height);
}

-(void) moveRightCByX:(CGFloat) xPoint width:(CGFloat) width {
  rightController.view.frame = CGRectMake(xPoint, leftController.view.frame.origin.y,
                                         width, leftController.view.frame.size.height);
}

-(void) moveRootCByX:(CGFloat) xPoint {
  
  centerController.view.frame = CGRectMake(xPoint, centerController.view.frame.origin.y,
                                           centerController.view.frame.size.width, centerController.view.frame.size.height);
  self.navigationController.navigationBar.frame = CGRectMake(xPoint, KNAVIGATION_BAR_Y, KSCREEN_WIDTH, KNAVIGATION_BAR_HEIGHT);
}

@end
