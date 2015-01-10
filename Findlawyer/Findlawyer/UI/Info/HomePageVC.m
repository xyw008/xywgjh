//
//  InfoViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "HomePageVC.h"
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
#import "NimbusWebController.h"
#import "CycleScrollView.h"
#import "HomePageNewsCell.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "GCDThread.h"

#define kCellHeight 35

#define LineBtnCount    3   // 一行平台btn的数量
#define BtnWidth        50  // 平台btn的宽度
#define BtnHeight       50  // 平台btn的高度
#define LabelHeight     20  // 平台名label的高度
#define BetweenHorizontalBtnAndBtnSpace ((self.view.boundsWidth - LineBtnCount * BtnWidth) / (LineBtnCount + 1)) // 横向btn和btn之间的间隙
#define BetweenVerticalBtnAndLabelSpace 10         // 纵向btn和label之间的间隙

@interface HomePageVC () <NetRequestDelegate, CycleScrollViewDelegate>
{
    UIView          *_rigitemTitleView;
    CycleScrollView *_cycleScrollView;
    
    NSMutableArray *_networkHomePageNewsEntitiesArray;
    NSMutableArray *_networkHomePageBannerEntitiesArray;
}
@property (nonatomic,strong)UIButton  *btnCity ;

@end

@implementation HomePageVC

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
//    [super initialize];
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

    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([HomePageNewsCell class])
                  reuseIdentifier:@"HomePageNewsCell"];
    
    _tableView.tableHeaderView = [self tabHeaderView];
    [_tableView reloadData];
    
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
    if (_rigitemTitleView) {
        
        _rigitemTitleView = nil;
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
    _rigitemTitleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  title_label.frame.size.width + img_view.frame.size.width + 10,
                                                                  MAX(title_label.frame.size.height, img_view.frame.size.height))];
    [_rigitemTitleView addSubview:title_label];
    [_rigitemTitleView addSubview:img_view];
    
    // add tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedRightButtonView:)];
    [_rigitemTitleView addGestureRecognizer:tapGesture];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rigitemTitleView];
}

- (UIView *)tabHeaderView
{
    NSArray *textsArray = @[@"附近律师",@"周边律所", @"我要咨询", @"待定1"];
    NSArray *imagesNameArray = @[@"btn_icon2", @"btn_icon1", @"btn_icon3", @"btn_icon4"];
    
    UIView *bgView = InsertView(nil, CGRectMake(0, 0, self.view.boundsWidth, 0));
    NSInteger itemCount = textsArray.count;
    
    int lineCount;          // 总共有多少行
    int lastLineItemCount;  // 最后一行的btn数量
    
    if (0 == itemCount % LineBtnCount)
    {
        lineCount = itemCount / LineBtnCount;
        lastLineItemCount = LineBtnCount;
    }
    else
    {
        lineCount = itemCount / LineBtnCount + 1;
        lastLineItemCount = itemCount % LineBtnCount;
    }
    
    int tempBtnTag = 1000;
    UIView *currentView = nil;
    
    // 行的循环
    for (int i = 0; i < lineCount; i++)
    {
        // 列的循环
        // 不是最后一行
        if (i != (lineCount - 1))
        {
            for (int k = 0; k < LineBtnCount; k++)
            {
                NSString *imageNameStr = imagesNameArray[tempBtnTag - 1000];
                NSString *titleStr = textsArray[tempBtnTag - 1000];
                
                UIButton *tempBtn = InsertImageButton(bgView, CGRectMake(k * (BtnWidth + BetweenHorizontalBtnAndBtnSpace) + BetweenHorizontalBtnAndBtnSpace, i * (BtnHeight + LabelHeight + BetweenVerticalBtnAndLabelSpace) + 10, BtnWidth, BtnHeight),
                                                      tempBtnTag,
                                                      [UIImage imageNamed:imageNameStr],
                                                      nil,
                                                      self,
                                                      @selector(clicked:));
                
                currentView = InsertLabel(bgView, CGRectMake(tempBtn.frameOriginX - 5, CGRectGetMaxY(tempBtn.frame) + 0, tempBtn.boundsWidth + 10, LabelHeight),
                                          NSTextAlignmentCenter,
                                          titleStr,
                                          SP13Font,
                                          [UIColor blackColor],
                                          NO);
                
                tempBtnTag++;
            }
        }
        else
        {
            for (int k = 0; k < lastLineItemCount; k++)
            {
                NSString *imageNameStr = imagesNameArray[tempBtnTag - 1000];
                NSString *titleStr = textsArray[tempBtnTag - 1000];
                
                UIButton *tempBtn = InsertImageButton(bgView, CGRectMake(k * (BtnWidth + BetweenHorizontalBtnAndBtnSpace) + BetweenHorizontalBtnAndBtnSpace, i * (BtnHeight + LabelHeight + BetweenVerticalBtnAndLabelSpace) + 10, BtnWidth, BtnHeight),
                                                      tempBtnTag,
                                                      [UIImage imageNamed:imageNameStr],
                                                      nil,
                                                      self,
                                                      @selector(clicked:));
                
                currentView = InsertLabel(bgView, CGRectMake(tempBtn.frameOriginX - 5, CGRectGetMaxY(tempBtn.frame) + 0, tempBtn.boundsWidth + 10, LabelHeight),
                                          NSTextAlignmentCenter,
                                          titleStr,
                                          SP13Font,
                                          [UIColor blackColor],
                                          NO);
                
                tempBtnTag++;
            }
        }
    }
    
    _cycleScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(currentView.frame) + 10, bgView.boundsWidth, 150) viewContentMode:ViewShowStyle_None delegate:self localImgNames:nil isAutoScroll:YES isCanZoom:NO];
    [bgView addSubview:_cycleScrollView];
    
    bgView.boundsHeight = CGRectGetMaxY(_cycleScrollView.frame);
    
    return bgView;
}

- (void)clicked:(UIButton *)sender
{
    NSInteger tag = sender.tag - 1000;
    if (tag == 0)
    {
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
//        SearchLawyerViewController *vc = (SearchLawyerViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchDetailLawyer"];
        
        SearchLawyerViewController *vc = [[SearchLawyerViewController alloc] init];
        vc.strTitle = @"附近律师";
        vc.searchKey = @"";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 1)
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
    else if (tag == 2)
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
    if (indexPath.row == 0)
    {
        return 60;
    }
    // 最后更多的新闻
    if (indexPath.row == _networkHomePageNewsEntitiesArray.count)
    {
        return 44;
    }
    return kCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _networkHomePageNewsEntitiesArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

     UITableViewCell *cell = nil;
     if (indexPath.row == 0)
     {
         cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageNewsCell" forIndexPath:indexPath];
         [cell addLineWithPosition:ViewDrawLinePostionType_Bottom startPointOffset:5 endPointOffset:5 lineColor:HEXCOLOR(0XD9D9D9) lineWidth:1];
         
         HomePageNewsEntity *entity = _networkHomePageNewsEntitiesArray[indexPath.row];
         UILabel *titleLabel = (UILabel *)[cell viewWithTag:1001];
         UILabel *descLabel = (UILabel *)[cell viewWithTag:1002];
         
         titleLabel.text = entity.newsTitleStr;
         descLabel.text = entity.newsDescStr;
     }
     else if(_networkHomePageNewsEntitiesArray.count == indexPath.row)
     {
         static NSString *moreIdentifier = @"moreCellIdentifier";
         cell = [tableView dequeueReusableCellWithIdentifier:moreIdentifier];
         if (!cell) {
             cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreIdentifier];
             CGFloat width = 80;
             UILabel *moreLB = [[UILabel alloc] initWithFrame:CGRectMake((tableView.width - width)/2 - 10, 0, width, 44)];
             moreLB.text = @"更多新闻";
             moreLB.textColor = [UIColor grayColor];
             moreLB.textAlignment = NSTextAlignmentCenter;
             moreLB.font = SP16Font;
             [cell.contentView addSubview:moreLB];
//             [cell addLineWithPosition:ViewDrawLinePostionType_Bottom startPointOffset:5 endPointOffset:5 lineColor:HEXCOLOR(0XD9D9D9) lineWidth:1];
             UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moreLB.frame), 16, 7, 12)];
             imgView.image = [UIImage imageNamed:@"home_moreNew"];
             [cell.contentView addSubview:imgView];
         }
     }
     else
     {
         HomePageNewsEntity *entity = _networkHomePageNewsEntitiesArray[indexPath.row];
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
    
    if (_networkHomePageNewsEntitiesArray.count == indexPath.row)
    {
        NIWebController *webVC = [[NIWebController alloc] initWithURL:[[NSURL alloc] initWithString:@"http://test3.sunlawyers.com/list.aspx"]];
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else
    {
        HomePageNewsEntity *entity = _networkHomePageNewsEntitiesArray[indexPath.row];
        NSString *urlStr = [NSString stringWithFormat:@"http://test3.sunlawyers.com/News.aspx?id=%d&islawyer=0",entity.newsId];
        NIWebController *web = [[NIWebController alloc] initWithURL:[NSURL URLWithString:urlStr]];
        /*
        InfoDetailViewController *newsDetailVC = [[InfoDetailViewController alloc] initWithNewsId:entity.newsId];
        newsDetailVC.hidesBottomBarWhenPushed = YES;
         */
        
        [self.navigationController pushViewController:web animated:YES];
    }
}

- (void)reloadCycleScrollViewData
{
    NSMutableArray *imgUrlStrArray = [NSMutableArray arrayWithCapacity:_networkHomePageBannerEntitiesArray.count];
    for (HomePageBannerEntity *entity in _networkHomePageBannerEntitiesArray)
    {
        [imgUrlStrArray addObject:entity.imgUrlStr];
    }
    
    _cycleScrollView.imageDataSourceArray = imgUrlStrArray;
    [_cycleScrollView configureUI];
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

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (NetHomePageNewsRequestType_GetMainNewsList == request.tag)
        {
            [strongSelf parseNetworkDataWithDic:successInfoObj];
            
            [strongSelf->_tableView reloadData];
            [strongSelf reloadCycleScrollViewData];
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetHomePageNewsRequestType_GetMainNewsList]
         parameterDic:nil
           requestTag:NetHomePageNewsRequestType_GetMainNewsList];
}

- (void)parseNetworkDataWithDic:(NSDictionary *)dic
{
    if ([dic isSafeObject] && [dic isAbsoluteValid])
    {
        // banner
        NSArray *bannerList = [dic objectForKey:@"AD"];
        if ([bannerList isAbsoluteValid])
        {
            _networkHomePageBannerEntitiesArray = [NSMutableArray arrayWithCapacity:bannerList.count];
            for (NSDictionary *oneBannerDic in bannerList)
            {
                HomePageBannerEntity *entity = [HomePageBannerEntity initWithDict:oneBannerDic];
                
                [_networkHomePageBannerEntitiesArray addObject:entity];
            }
        }
        // news list
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

#pragma mark - CycleScrollViewDelegate methods

- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index
{
    HomePageBannerEntity *entity = _networkHomePageBannerEntitiesArray[index];
    NIWebController *web = [[NIWebController alloc] initWithURL:[NSURL URLWithString:entity.newsUrlStr]];
    
    [self.navigationController pushViewController:web animated:YES];
}

@end
