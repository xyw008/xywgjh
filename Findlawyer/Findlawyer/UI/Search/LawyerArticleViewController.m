//
//  LawyerArticleViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "LawyerArticleViewController.h"
#import "Network.h"
#import "UIView+ProgressHUD.h"
#import "HUDManager.h"

#ifndef ProHUD
#define ProHUD	199
#endif

@interface LawyerArticleViewController ()

@end

@implementation LawyerArticleViewController

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
    self.lbTitile.text = self.dicArticle[@"Title"];
    self.lbLaunchTime.text = self.dicArticle [@"DateTime"];
    
    CGFloat statusBarHigh = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat high = [UIScreen mainScreen].bounds.size.height - statusBarHigh - navBarHigh-55;
    self.textView = [[UITextView  alloc] initWithFrame: CGRectMake(10, 55, self.view.frame.size.width - 10 *2, high)];
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字
    [self.view addSubview:self.textView];
    self.textView.editable = NO;
    [self loadArticle];
//    self.textView.text = @"每个人年轻的时候都会做出很多荒唐错误的事情，而那些看似让人后悔和自责的决定其实没有对错之分，它们就像成长里的必修课，人生里的很多事从来无法靠汲取前辈的经验来理解和学习，只有当自己真的经历一遍后才会恍然大悟，醍醐灌顶。年轻时的选择从来没有绝对的对与错，因为只有经历之后你才会知道究竟什么是对是错。你错得越多，成长得就会越快，你伤得有多重，日后就会有多强壮。人不能被同一块石头绊倒两次，也不能在同样的深渊里跌入两回，可你若没有被绊倒过一次，没有陷入过一次，你便不会获得独自爬起的能力。当你陷入过一次后，才会勇敢地告诉自己“再不需要搭救”。而让人庆幸的可我们又常常忘记的是，我们还年轻。因为年轻，我们有足够的资本触底反弹，因为年轻，潮落之后，一定会有潮起，年轻的时候不吃点苦犯些错，日后可能会犯下不可挽回的错误，留下无法弥补的悔恨。这一切的错，一切的悔都是成长道路上无比珍贵的宝石，而只有当我们经历后才可以将它们揣入囊中。一件事情，无论会遇到多少困难，结果有多大把握，这些并不重要，只要是你自己的选择，就不存在对错与后悔，关键是你有没有挣脱束缚的勇气，有没有走出这一步的决心。年轻时的我们，最怕的就是用四十岁的心过二十岁的生活，少了本该年轻气盛的魄力，不要在开始前踌躇满志又畏首畏尾，不要在中途一腔热血却又瞻前顾后，用力地踏出第一步，更用力地走完后面的每一步，那才应该是二十岁的你，那才是你应该有过的青春。从你不怕坠落的那一刻开始，天空就离你不远了，有时候人只有先勇敢地跳下去才能学会如何飞翔。趁你还年轻，不要怕走错路，你拥有走错路的资本，而你所走错过的每一条路的懂得与领悟，日后都会化为你的王牌阅历。";

}

// 加载律师文章信息
- (void)loadArticle
{
    
    NSInteger articleid = [self.dicArticle [@"Id"] integerValue];
    __weak LawyerArticleViewController *weakSelf = self;
    NetReturnType ret = [[Network sharedNetwork]loadArticleInforWithID:articleid completion:^(NSInteger result, NSString *message, id userInfo) {
        
        if (userInfo) {
            NSArray * ar = userInfo[@"Article"];
            NSDictionary *dic = [ar objectAtIndex:0];
            weakSelf.textView.text = dic[@"Content"];
        }
//        [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
        [HUDManager showAutoHideHUDWithToShowStr:@"加载完毕" HUDMode:MBProgressHUDModeText];
    }];
    
    if ( ret == NetBeginRequest)
    {
//        [UIView showHUDWithTitle:@"加载中..." onView:self.view tag:ProHUD];
        [HUDManager showHUDWithToShowStr:@"加载中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
    }
    else if  ( ret == NetworkDisenable)
    {
//        [UIView  showHUDWithTitle:@"网络不给力！" image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
        [HUDManager showAutoHideHUDWithToShowStr:@"网络不给力！" HUDMode:MBProgressHUDModeText];
    }
    else
    {
//        [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
        [HUDManager showAutoHideHUDWithToShowStr:@"加载失败..." HUDMode:MBProgressHUDModeText];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    CGFloat statusBarHigh = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat high = [UIScreen mainScreen].bounds.size.height - statusBarHigh - navBarHigh-55;
    self.textView.frame = CGRectMake(10, 55, self.view.frame.size.width - 10 *2, high);
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
