//
//  InfoDetailViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-7-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "InfoDetailViewController.h"

@interface InfoDetailViewController ()

@end

@implementation InfoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    
    
 [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
