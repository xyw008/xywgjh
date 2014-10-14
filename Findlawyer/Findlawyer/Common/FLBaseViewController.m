//
//  BaseViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "FLBaseViewController.h"

@interface FLBaseViewController ()

@end

@implementation FLBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // Do any additional setup in subClass.
}

- (void)setLeftBarbuttonTitle:(NSString *)titile
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:titile
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backToPrevious)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backToPrevious
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)showNodataIndicatorWithText:(NSString *)text image:(UIImage *)image
{
    [self hideNodataIndicator];
    
    if (text)
    {
        self.nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 21)];
        self.nodataLabel.backgroundColor = [UIColor clearColor];
        self.nodataLabel.textColor = [UIColor grayColor];
        self.nodataLabel.text = text;
        self.nodataLabel.textAlignment = NSTextAlignmentCenter;
        self.nodataLabel.font = [UIFont systemFontOfSize:15.0];
        [self.view addSubview:self.nodataLabel];
        
        [self.nodataLabel sizeToFit];
        CGRect frame = self.nodataLabel.frame;
        frame.origin = CGPointMake((self.view.frame.size.width - frame.size.width)/2.0, (self.view.frame.size.height - frame.size.height)/2.0);
        self.nodataLabel.frame = frame;
    }
    
    if (image)
    {
        self.nodataIcon = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:self.nodataIcon];
        
        [self.nodataIcon sizeToFit];
        CGFloat offset = (text ? 21 : 0);
        CGRect frame = self.nodataIcon.frame;
        frame.origin = CGPointMake((self.view.frame.size.width - frame.size.width)/2.0, (self.view.frame.size.height - frame.size.height)/2.0 - offset);
        self.nodataIcon.frame = frame;
    }
}

- (void)hideNodataIndicator
{
    if (self.nodataLabel)
    {
        [self.nodataLabel removeFromSuperview];
        self.nodataLabel = nil;
    }
    
    if (self.nodataIcon)
    {
        [self.nodataIcon removeFromSuperview];
        self.nodataIcon = nil;
    }
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
