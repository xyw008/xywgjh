//
//  InfoViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "InfoViewController.h"
#import "CityListViewController.h"
#import "QSignalManager.h"
#import "FileManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SearchDeatalViewController.h"
#import "SearchLawyerViewController.h"

#import "UrlManager.h"
#import "NetRequestManager.h"
#import "CommonEntity.h"
#import "HUDManager.h"
#import "InfoDetailViewController.h"

@interface InfoViewController () <NetRequestDelegate>
{
    UIView * rigitemTitleView;
    
    NSMutableArray *_networkHomePageNewsEntitiesArray;
}
@property (nonatomic,strong)UIButton  *btnCity ;

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    [self addSignalObserver];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  //   self.navigationController.navigationBar.translucent = YES;
    
    UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:imgview];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIImage *middleBtnBGImage = [UIImage imageNamed:@"navTitleBtn"];
    UIButton *middleBtn = InsertImageButton(nil, CGRectMake(0, 0, middleBtnBGImage.size.width, middleBtnBGImage.size.height), 1000, middleBtnBGImage, middleBtnBGImage, self, @selector(clickNavBarTitleBtn:));
    self.navigationItem.titleView = middleBtn;
    
    NSString * currentcity = [FileManager currentCity];
    if (currentcity.length == 0)
    {
        [self customNavigationRightBtnViewByTitle:@"深圳"];
    }
    else
    {
        [self customNavigationRightBtnViewByTitle:currentcity];
    }

    [self customTitleView];
    self.tableView.tableHeaderView = self.titileview;

    [self.tableView reloadData];
    
    // 请求网络数据
    [self getNetworkData];

}

- (void)clickNavBarTitleBtn:(UIButton *)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate chooseMaintabIndex:1 andType:sender.tag];
}

- (void)receiveSignal:(QSignal *)signal
{
    if ([signal.name isEqualToString:ChangeCitySignal]) {
      //  NSDictionary * userinfo = signal.userInfo;
      //  NSString  *city = [userinfo objectForKey:@"city"];
        NSString  *city = [FileManager currentCity];
        [self customNavigationRightBtnViewByTitle:city];
    }
}

- (void)customNavigationRightBtnViewByTitle:(NSString *)titile
{
    if (rigitemTitleView) {
        
        rigitemTitleView = nil;
       self.navigationItem.rightBarButtonItem = nil;
    }
    // add title label
    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectZero];
    title_label.text = titile;
    title_label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    title_label.backgroundColor = [UIColor clearColor];
    title_label.font = [UIFont boldSystemFontOfSize:16.0];
    [title_label sizeToFit];
    // limit width
    CGRect titleLabelFrame = title_label.frame;
    titleLabelFrame.size.width = MIN(titleLabelFrame.size.width, 160);
    title_label.frame = titleLabelFrame;
    UIImageView *img_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btnChangecity"]];
    [img_view sizeToFit];
    
//    img_view.transform = CGAffineTransformMakeRotation(1.57);
//    
    CGRect img_frame = img_view.frame;
    img_frame.origin.x = CGRectGetMaxX(titleLabelFrame) + 5;
    img_frame.origin.y = (titleLabelFrame.size.height - img_frame.size.height) / 2.0;
    img_view.frame = img_frame;
    
    // add title view
    rigitemTitleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  title_label.frame.size.width + img_view.frame.size.width + 10,
                                                                  MAX(title_label.frame.size.height, img_view.frame.size.height))];
    [rigitemTitleView addSubview:title_label];
    [rigitemTitleView addSubview:img_view];
    
    // add tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedRightButtonView:)];
    [rigitemTitleView addGestureRecognizer:tapGesture];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rigitemTitleView];
}

- (void)customTitleView
{
    self.titileview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10+60 *2 +20*2+5+90+10)];
    
    CGRect frame;
    CGRect lframe;
    
    NSString *texts[] = {@"附近律师",@"周边律所", @"我要咨询", @"待定1", @"待定2", @"待定3"};
    
    NSString *images[] = {@"btn_icon2", @"btn_icon1", @"btn_icon3", @"btn_icon4", @"btn_icon5", @"btn_icon5"};
    
    NSString *cimages[] = {@"btn_icon2", @"btn_icon1", @"btn_icon3", @"btn_icon4", @"btn_icon5", @"btn_icon5"};
    
    int index = 0;
    frame.origin = CGPointMake(35, 10);
    frame.size = CGSizeMake(60, 60);
    
    for ( int i = 0; i < 1; i++ ) {
        for ( int j = 0; j < 3; j++ ) {
            
            UIImage *image = [UIImage imageNamed:images[index]];
           // frame.size = image.size;
            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:cimages[index]] forState:UIControlStateHighlighted];
            [self.titileview addSubview:button];
            button.tag = index++;
            [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
            
            lframe = frame;
            lframe.origin.x -= 15;
            lframe.origin.y += frame.size.height + 2;
            lframe.size.height = 16;
            lframe.size.width += 30;
            UILabel *label = [[UILabel alloc] initWithFrame:lframe];
            label.text = texts[index-1];
            label.font = [UIFont boldSystemFontOfSize:13.0];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.titileview addSubview:label];
            frame.origin.x += 60 +35;
        }
        frame.origin.x = 35;
        frame.origin.y += 60+20 ;
    }
 
    UIView *bgAD = [[UIView alloc]initWithFrame:CGRectMake(0,10+ 60 *2  +20*2+5 , self.view.frame.size.width , 90)];
    bgAD.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.titileview addSubview:bgAD];
    
    UIImageView *imgAD =[[UIImageView alloc]initWithFrame:CGRectMake(10, 5 , self.view.frame.size.width-10*2, 80)];
    imgAD.image = [UIImage imageNamed:@"lawfirmSmal"];
    imgAD.layer.masksToBounds = YES;
    imgAD.layer.cornerRadius = 5;
    imgAD.layer.borderColor = [[UIColor groupTableViewBackgroundColor]CGColor];
    [bgAD addSubview:imgAD];
   
  //  return self.titileview;
}

- (void)clicked:(UIButton *)sender
{
    if (sender.tag == 0)
    {
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        SearchLawyerViewController *vc = (SearchLawyerViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchDetailLawyer"];
        SearchLawyerViewController *vc = [[SearchLawyerViewController alloc] init];
        vc.strTitle = @"附近律师";
        vc.searchKey = @"";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 1)
    {
        
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        SearchDeatalViewController *vc = (SearchDeatalViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchDetailLawfirm"];
        
        SearchDeatalViewController *vc = [[SearchDeatalViewController alloc] init];
        vc.searchKey = @"";
        vc.strTitle = @"周边律所";
        vc.isShowMapView = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 2)
    {
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate chooseMaintabIndex:2 andType:sender.tag];
    }

}

- (void)pressedRightButtonView:(id)sender
{
//    CityListViewController * cityListVC = [[CityListViewController alloc]init];
//    [self.navigationController pushViewController:cityListVC animated:YES];
    [self performSegueWithIdentifier:@"TocityLIst" sender:self];
}

#pragma mark -UITableViewDelegate UITabevieDataSource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0)
    {
        return 60;
    }
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _networkHomePageNewsEntitiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

     HomePageNewsEntity *entity = _networkHomePageNewsEntitiesArray[indexPath.row];
     UITableViewCell *cell = nil;
     if (indexPath.row == 0)
     {
         cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
         [cell addLineWithPosition:ViewDrawLinePostionType_Bottom startPointOffset:5 endPointOffset:5 lineColor:HEXCOLOR(0XD9D9D9) lineWidth:1];
         
         UILabel *titleLabel = (UILabel *)[cell viewWithTag:1001];
         UILabel *descLabel = (UILabel *)[cell viewWithTag:1002];
         
         titleLabel.text = entity.newsTitleStr;
         descLabel.text = entity.newsDescStr;
     }
     else
     {
         cell = [tableView dequeueReusableCellWithIdentifier:@"sigleCell"];
         if (!cell)
         {
             cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sigleCell"];
             cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
             cell.textLabel.textColor = [UIColor blackColor];
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
             [cell addLineWithPosition:ViewDrawLinePostionType_Bottom startPointOffset:5 endPointOffset:5 lineColor:HEXCOLOR(0XD9D9D9) lineWidth:1];
         }
         cell.textLabel.text = entity.newsTitleStr;
     }
   
    return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toInfoDetail" sender:self];
     */
    HomePageNewsEntity *entity = _networkHomePageNewsEntitiesArray[indexPath.row];
    InfoDetailViewController *newsDetailVC = [[InfoDetailViewController alloc] initWithNewsId:entity.newsId];
    newsDetailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:newsDetailVC animated:YES];
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeSignalObserver];
}

#pragma mark - custom methods

- (void)getNetworkData
{
    NSURL *url = [UrlManager getRequestUrlByMethodName:@"GetTop5MainNewsList"];
    
    [[NetRequestManager sharedInstance] sendRequest:url parameterDic:nil requestTag:1000 delegate:self userInfo:nil];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [self parseNetworkDataWithDic:infoObj];
    [self.tableView reloadData];
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [HUDManager showAutoHideHUDWithToShowStr:LoadFailed HUDMode:MBProgressHUDModeText];
}

- (void)parseNetworkDataWithDic:(NSDictionary *)dic
{
    if ([dic isAbsoluteValid])
    {
        NSArray *newsList = [dic objectForKey:@"MainNews"];
        if ([newsList isAbsoluteValid])
        {
            _networkHomePageNewsEntitiesArray = [NSMutableArray arrayWithCapacity:newsList.count];
            for (NSDictionary *oneNewsDic in newsList)
            {
                HomePageNewsEntity *entity = [HomePageNewsEntity initWithDict:oneNewsDic];
                
                [_networkHomePageNewsEntitiesArray addObject:entity];
            }
        }
    }
}

@end
