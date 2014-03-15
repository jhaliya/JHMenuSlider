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
} JHOpenView;

#define kMenuTransformScale CATransform3DMakeScale(0.85, 0.85, 0.85)
#define kMenuLayerInitialOpacity 0.4f

@implementation JHRootViewController {
  JHLeftViewController *leftController;
  JHCenterViewController *centerController;
  JHRightViewController *rightController;
  
  UIPanGestureRecognizer *panGestureRecognizer;
  
  JHOpenView openView;
  BOOL isFingerLift;
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
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    leftController = [[JHLeftViewController alloc] initWithNibName:nil bundle:nil];
    centerController = [[JHCenterViewController alloc] initWithNibName:nil bundle:nil];
    rightController = [[JHRightViewController alloc] initWithNibName:nil bundle:nil];

    leftController.view.autoresizesSubviews = YES;
    centerController.view.autoresizesSubviews = YES;
    rightController.view.autoresizesSubviews = YES;

    leftController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    centerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    rightController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:leftController.view];
    [self.view addSubview:rightController.view];
    [self.view addSubview:centerController.view];

    //Shadow effect
    //[self controllerShadow:leftController];
    [self controllerShadow:centerController];
    //[self controllerShadow:rightController];
    openView = ERootView;
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

-(JHOpenView) openViewState {
  return openView;
}
-(void)viewWillAppear:(BOOL)animated  {
  [super viewWillAppear:animated];
  centerController.view.frame = self.view.frame;
  leftController.view.frame =  CGRectMake(0, 0, self.view.frame.size.width-KREVEAL_GAP,
                                          self.view.frame.size.height);
  rightController.view.frame =  CGRectMake(KREVEAL_GAP, 0, self.view.frame.size.width-KREVEAL_GAP,
                                           self.view.frame.size.height);
  
  panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
  [panGestureRecognizer addTarget:self action:@selector(handlePanGestureRecognizer:)];
  
  eventView = [[UIView alloc] initWithFrame:self.view.bounds];
  eventView.backgroundColor = [UIColor clearColor];
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
  CGRect cRect;
  
  if(openView  == ERootView) {
    openView = ERightView;
    if([[self.view subviews] indexOfObject:rightController.view] == 0) {
      [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    cRect = CGRectMake(KREVEAL_GAP-self.view.bounds.size.width, 0, self.view.frame.size.width,
                            self.view.frame.size.height);
  } else {
    openView = ERootView;
    cRect  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  
  [UIView animateWithDuration:KANIMATION_TIME delay:KANIMATION_DELAY usingSpringWithDamping:KSPRING_WITH_DAMPING
        initialSpringVelocity:KINITIAL_SPRING_VALOCITY options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                        centerController.view.frame = cRect;
                        self.navigationController.navigationBar.frame = CGRectMake(cRect.origin.x, KNAVIGATION_BAR_Y, self.view.bounds.size.width, KNAVIGATION_BAR_HEIGHT);
                      } completion:nil];
}

-(void) leftRootButtonBarEvent:(id)sender {
  
  CGRect cRect;
  
  if(openView  == ERootView) {
    openView = ELeftView;
    if([[self.view subviews] indexOfObject:leftController.view] == 0) {
      [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    }
    cRect = CGRectMake(self.view.bounds.size.width - KREVEAL_GAP, 0, self.view.frame.size.width - KREVEAL_GAP,
                            self.view.frame.size.height);
  } else {
    openView = ERootView;
    cRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  
  [UIView animateWithDuration:KANIMATION_TIME delay:KANIMATION_DELAY usingSpringWithDamping:KSPRING_WITH_DAMPING
        initialSpringVelocity:KINITIAL_SPRING_VALOCITY options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                        centerController.view.frame = cRect;
                     self.navigationController.navigationBar.frame = CGRectMake(cRect.origin.x, KNAVIGATION_BAR_Y, self.view.bounds.size.width, KNAVIGATION_BAR_HEIGHT);
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
  NSLog(@"didRotateFromInterfaceOrientation %@", NSStringFromCGRect(self.view.bounds));
  eventView.frame = self.view.bounds;
  self.navigationController.navigationBar.frame = CGRectMake(centerController.view.frame.origin.x, KNAVIGATION_BAR_Y, centerController.view.frame.size.width , KNAVIGATION_BAR_HEIGHT);
}

#pragma mark - Gesture Recognizers -

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap {
  NSLog(@"handleTapGesture");
  if(openView == ELeftView) {
    [self leftRootButtonBarEvent:nil];
  } else if( openView == ERightView) {
    [self rightRootButtonBarEvent:nil];
  }
}

-(void) changeUnderneathView:(BOOL) toRightView {
  
  if(!toRightView) {
    NSLog(@"Changing from left to right ");
    if([[self.view subviews] indexOfObject:leftController.view] == 0) {
      [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
      }
    } else {
      NSLog(@"Changing from right to left");
      if([[self.view subviews] indexOfObject:rightController.view] == 0) {
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
      }
    }
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
  
  CGPoint translation = [gesture translationInView:centerController.view];
  //CGPoint pointInView = [gesture locationInView:centerController.view];
  
  NSLog(@"translation -->%@",NSStringFromCGPoint(translation));
  //NSLog(@"pointInView -->%@",NSStringFromCGPoint(pointInView));

  //CGFloat pointScale = translation.x * 1.5;
  
  if([gesture state] == UIGestureRecognizerStateBegan) {
    isFingerLift = YES;
    if( openView == ERootView)
      isFingerLift = NO;
    NSLog(@"UIGestureRecognizerStateBegan");
  } else if([gesture state] == UIGestureRecognizerStateEnded) {
    isFingerLift = YES;
    if(centerController.view.frame.origin.x > 0) {
      if(centerController.view.frame.origin.x < 100) {
        openView  = ELeftView;
      } else if(centerController.view.frame.origin.x > 200) {
        openView = ERootView;
      }
      [self leftRootButtonBarEvent:nil];
    } else {
      if(centerController.view.frame.origin.x < -100) {
        openView  = ERootView;
      } else if(centerController.view.frame.origin.x > -200) {
        openView = ERightView;
      }
      [self rightRootButtonBarEvent:nil];
    }
    NSLog(@"UIGestureRecognizerStateEnded");
  } else if([gesture state] == UIGestureRecognizerStateChanged) {

   //NSLog(@"UIGestureRecognizerStateChanged");
    //NSLog(@"pointScale ... -->%f",pointScale);
    NSLog(@" open view %@", (openView == 0 ? @"Left view open":(openView  ==  1 ? @"Root view open" : @"Right view open")));
    
    if(openView == ERootView) {
      [self changeUnderneathView:(translation.x < 0)];
      NSLog(@"It's ROOT view now: with center frame %@",NSStringFromCGRect(centerController.view.frame));
      if((translation.x > 0)) {
        if(centerController.view.frame.origin.x <= (self.view.frame.size.width - KREVEAL_GAP)) {
          [self moveRootCByX:translation.x width:self.view.frame.size.width];
        } else {
          [self moveRootCByX:(self.view.frame.size.width - KREVEAL_GAP) width:self.view.frame.size.width];
          openView = ELeftView;
          NSLog(@"Set to LEFT from ROOT view in if(translation.x > 0)");
        }
      } else {
        if(centerController.view.frame.origin.x >= -(self.view.frame.size.width - KREVEAL_GAP)) {
          [self moveRootCByX:translation.x width:self.view.frame.size.width];
        } else {
          [self moveRootCByX:-(self.view.frame.size.width - KREVEAL_GAP) width:self.view.frame.size.width];
          openView = ERightView;
          NSLog(@"Set to RIGHT from ROOT view in if(translation.x < 0)");
        }
      }
    } else if (openView == ELeftView) {
      NSLog(@"It's LEFT view now: with center frame %@",NSStringFromCGRect(centerController.view.frame));
      if(!isFingerLift) {
        if(translation.x >= (self.view.frame.size.width - KREVEAL_GAP)) {
          [self moveRootCByX:(self.view.frame.size.width - KREVEAL_GAP) width:self.view.frame.size.width];
        } else  if(centerController.view.frame.origin.x <= 0) {
          [self moveRootCByX:0 width:self.view.frame.size.width];
          NSLog(@"Set to ROOT from LEFT view in isFingerLift ");
          openView = ERootView;
        } else {
          [self moveRootCByX:translation.x width:self.view.frame.size.width];
        }
      } else if(translation.x < 0) {
        if(translation.x > -(self.view.frame.size.width - KREVEAL_GAP)) {
          CGFloat pointX = (self.view.frame.size.width - KREVEAL_GAP) + translation.x;
          [self moveRootCByX:pointX width:self.view.frame.size.width];
        } else {
          [self moveRootCByX:0 width:self.view.frame.size.width];
          NSLog(@"Set to ROOT from LEFT view in if(translation.x < 0)");
          openView = ERootView;
        }
      } else if(centerController.view.frame.origin.x >= (self.view.frame.size.width - KREVEAL_GAP)) {
        [self moveRootCByX:(self.view.frame.size.width - KREVEAL_GAP) width:self.view.frame.size.width];
      } else {
        [self moveRootCByX:0 width:self.view.frame.size.width];
        openView = ERootView;
      }
    } else if (openView == ERightView) {
      NSLog(@"It's RIGHT view now: with center frame %@",NSStringFromCGRect(centerController.view.frame));
      if(!isFingerLift) {
        if(translation.x <= -(self.view.frame.size.width - KREVEAL_GAP)) {
          [self moveRootCByX:-(self.view.frame.size.width - KREVEAL_GAP) width:self.view.frame.size.width];
        } else  if(centerController.view.frame.origin.x >= 0) {
          [self moveRootCByX:0 width:self.view.frame.size.width];
          NSLog(@"Set to ROOT from RIGHT view in isFingerLift ");
          openView = ERootView;
        } else {
          [self moveRootCByX:translation.x width:self.view.frame.size.width];
        }
      } else if(translation.x > 0) {
        CGFloat pointX = -(self.view.frame.size.width - KREVEAL_GAP) + translation.x;
        [self moveRootCByX:pointX width:self.view.frame.size.width];
      }
    }
  }
}

-(void) moveRootCByX:(CGFloat) xPoint width:(CGFloat) width {
  
  centerController.view.frame = CGRectMake(xPoint, centerController.view.frame.origin.y,
                                           width, centerController.view.frame.size.height);
  self.navigationController.navigationBar.frame = CGRectMake(xPoint, KNAVIGATION_BAR_Y, width , KNAVIGATION_BAR_HEIGHT);
}

@end
