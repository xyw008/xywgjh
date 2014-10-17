//
//  InfoDetailViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-7-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "BaseNetworkViewController+NetRequestManager.h"

@interface InfoDetailViewController ()
{
    NSInteger _newsId;
    
    UIWebView *_webView;
}

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

- (id)initWithNewsId:(NSInteger)newsId
{
    self = [super init];
    if (self)
    {
        _newsId = newsId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationItemTitle:@"资讯详情"];
    
    [self initialization];
    [self getNetworkData];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        
        STRONGSELF
        if ([successInfoObj isSafeObject])
        {
            NSArray *newsList = [successInfoObj objectForKey:@"MainArticle"];
            if ([newsList isAbsoluteValid])
            {
                NSDictionary *newsDic = newsList[0];
                
                NSString *newsTitle = [newsDic objectForKey:@"Title"];
                NSString *newsContent = [newsDic objectForKey:@"Content"];
                
                [weakSelf setNavigationItemTitle:newsTitle];
                
                newsContent = [NSString stringWithFormat:
                                    @"<html> \n"
                                     "<head> \n"
                                     "<style type=\"text/css\"> \n"
                                     "body {font-family: \"%@\"; font-size: %f; color: %@; line-height: %@}\n"
                                     "</style> \n"
                                     "</head> \n"
                                     "<body>%@</body> \n"
                                     "</html>", @"黑体", 18.0, @"#000000", [NSString stringWithFormat:@"%fpx",18.0 + 10.0], newsContent];
                [strongSelf->_webView loadHTMLString:newsContent baseURL:nil];
            }
        }
    }];
}

- (void)getNetworkData
{
    if (_newsId)
    {
        [self sendRequest:[[self class] getRequestURLStr:NetHomePageNewsRequestType_GetMainNewsDetail] parameterDic:@{@"id":@(_newsId)} requestTag:NetHomePageNewsRequestType_GetMainNewsDetail];
    }
}

- (void)initialization
{
    _webView = InsertWebView(self.view, self.view.bounds, nil, 1000);
    [_webView keepAutoresizingInFull];
}

@end
