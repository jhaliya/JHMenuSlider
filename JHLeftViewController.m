//
//  JHLeftViewController.m
//  JHMenuSlider
//
//  Created by Praveen Sharma on 08/02/14.
//  Copyright (c) 2014 Jhaliya. All rights reserved.
//

#import "JHLeftViewController.h"


@implementation JHLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor redColor];
  UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
  label.center = self.view.center;
  label.text = @"Left view controller";
  label.textColor = [UIColor blueColor];
  [self.view addSubview:label];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
