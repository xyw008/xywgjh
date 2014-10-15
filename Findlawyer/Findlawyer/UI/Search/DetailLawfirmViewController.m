//
//  DetailLawfirmViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-8-21.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "DetailLawfirmViewController.h"
#import "LBSLawfirm.h"
#import "LBSLawyer.h"
#import "Network.h"
#import "UIView+ProgressHUD.h"
#import "DetailLawfirmHeaderView.h"
#import "LawfirmCell.h"
#import "UIImageView+WebCache.h"
#import "LawyerCell.h"
#import "LBSDataBase.h"
#import "LBSRequestManager.h"
#import "LBSRequest+LBSSearchRegion.h"
#import "LBSRequest+LBSSearchNearby.h"
#import "LBSDataCenter.h"
#import "LBSSharedData.h"
#import "DetailLocationViewController.h"
#import "QSignalManager.h"
#import "DetailLawyerViewController.h"
#import <MessageUI/MessageUI.h>
#import "ACETelPrompt.h"


#define ProHUD 199
#define kHeardHeight 18

@interface DetailLawfirmViewController ()<MFMessageComposeViewControllerDelegate>
{
  	NSUInteger currentIndex;
	NSUInteger pageSize;
	NSUInteger totalItemCount;
}

@property (assign, atomic) BOOL loading;
@property (assign, atomic) BOOL noMoreResultsAvail;
@property (assign, atomic) BOOL isLocationBasedSearch;
@property (assign, atomic) BOOL isHaveResult;

@property (strong,nonatomic)UILabel * lbshow;
@property (strong, nonatomic)NSMutableArray * muarLawyerlist;
@property (strong,nonatomic) LBSLawyer * seletedlawyer;
@property (nonatomic)BOOL ifhavedload;


@end

@implementation DetailLawfirmViewController

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
   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentIndex = 0;
    pageSize = 30;
    self.ifhavedload = YES;
    self.muarLawyerlist = [[NSMutableArray alloc]init];
    self.title = self.lawfirm.name;
   [self.tableView registerNib:[UINib nibWithNibName:@"LawyerCell" bundle:nil] forCellReuseIdentifier:@"LawyerCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];

}
-(void)viewWillAppear:(BOOL)animated
{
    if (self.ifhavedload) {
         [self loadData];
        self.ifhavedload = NO;
    }
    [self addSignalObserver];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self removeSignalObserver];
}

- (void)loadData
{
    __weak DetailLawfirmViewController *weakSelf = self;
    
    //加载律所信息
    NetReturnType ret = [[Network sharedNetwork]loadlawfirmInfoWithID:self.lawfirmid completion:^(NSInteger result, NSString *message, NSDictionary * userInfo) {
        if (result) {
            
            if (userInfo) {
                
                NSArray * contents = userInfo[@"LawFirm"];
                NSDictionary * dic = [contents objectAtIndex:0];
                weakSelf.lawfirm.tel = dic[@"Tel"];
                weakSelf.lawfirm.fax = dic [@"Fax"];
                weakSelf.lawfirm.detailaddress = dic [@"Address"];
                weakSelf.lawfirm.detail = dic [@"Detail"];
                weakSelf.lawfirm.mailBox = dic [@"Mail"];
                NSArray *arlist = [dic[@"PhotoUrlNameList"]componentsSeparatedByString:@"|"];
                
                if (weakSelf.lawfirm.arImageUrlstrs.count >0)
                {
                    [weakSelf.lawfirm.arImageUrlstrs removeAllObjects];
                }
                
                
                for (int i = 0; i < arlist.count; i ++)
                {
                    NSString *strUrl = [NSString stringWithFormat:@"http://test3.sunlawyers.com/upImg/%@",[arlist objectAtIndex:i]];
                    [weakSelf.lawfirm.arImageUrlstrs addObject:strUrl];
                }
                
                //律所具体信息展示界面
                DetailLawfirmHeaderView * detailheaderview = [[[NSBundle mainBundle] loadNibNamed:@"DetailLawfirmHeaderView" owner:self options:nil] lastObject];
                [detailheaderview configViewWithmainImage:weakSelf.lawfirm.mainImageURL
                                           introimagelist:weakSelf.lawfirm.arImageUrlstrs
                                                    Count:weakSelf.lawfirm.memberCount
                                                   adress:dic [@"Address"]
                                                    phone:weakSelf.lawfirm.tel
                                                netAdress:weakSelf.lawfirm.mailBox
                                                      fax: dic [@"Fax"]
                                               detailInfo:dic [@"Detail"]];
                weakSelf.tableView.tableHeaderView = detailheaderview;
                [self loadLocalData];
            }

        }
        else
        {
      
           [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];      
        }
              // [self loadlawyerlist];
        
 
    }];
    if ( ret == NetBeginRequest)
    {
        [UIView showHUDWithTitle:@"加载中..." onView:self.view tag:ProHUD];
    }
    else if  ( ret == NetworkDisenable)
    {
        [UIView  showHUDWithTitle:@"网络不给力！" image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
    }
    else
    {
        [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
    }
    
}

// 加载律师列表
- (void)loadLocalData
{
    __weak  DetailLawfirmViewController * weakSelf = self;
    [[LBSDataCenter defaultCenter] loadDataWithRegionSearchkey:self.lawfirm.name searchtype:searchLawyer index:currentIndex pageSize:pageSize pieceComplete:^(LBSRequest *request, id dataModel) {
        if (dataModel)
		{
            // 得到数据后，放到此律所的律师列表里
            LBSLawyer *lawyer= [[LBSLawyer alloc]initWithDataModel:dataModel];
            [weakSelf.muarLawyerlist addObject:lawyer];
        }
		else
		{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reload data now.");
				totalItemCount = request.availableItemCount;
				NSLog(@"total:%d, loaded:%d", totalItemCount, [weakSelf.muarLawyerlist count]);
				NSUInteger curCnt = [weakSelf.muarLawyerlist count];
				if (curCnt >= totalItemCount)
					_noMoreResultsAvail = YES;
				if (request.error)

                    [UIView hideHUDWithTitle:LBSUINetWorkError image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
				else if (request.availableItemCount)

                      [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
				else
                    [UIView hideHUDWithTitle:@"加载完毕"image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
                
				[weakSelf.tableView reloadData];
                
            });
        }
        
    }];
    currentIndex++;
	[[LBSSharedData sharedData] setCurrentIndex:currentIndex];
    
  
    
}

// 处理cell中各种button按了以后发出的通知
- (void)receiveSignal:(QSignal *)signal
{
    if ([signal.name isEqualToString:SignalCellShowMap]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.muarLawyerlist objectAtIndex:cellindexpath.row];
        [self showMap];
    }
    else if ([signal.name isEqualToString:SignalCellCall]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.muarLawyerlist objectAtIndex:cellindexpath.row];
        [self callNumber];
    }
    else if ([signal.name isEqualToString:SignalCellSendSms]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.muarLawyerlist objectAtIndex:cellindexpath.row];
        [self senSms];
    }
    else if ([signal.name isEqualToString:SignalCellConSult]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.muarLawyerlist objectAtIndex:cellindexpath.row];
        [self consult];
    }

}
// 显示地图
- (void)showMap
{
    NSLog(@"CellShowMap");
    [self performSegueWithIdentifier:@"Detaillawfirm_lawyertoDetailLawfirmLocation" sender:self];
}
// 发短信
- (void)senSms
{
    NSLog(@"CellSenSms");
    [self presentMessageComposeViewControllerWithNumber:self.seletedlawyer.mobile];
}

//拨打电话
- (void)callNumber
{
    NSLog(@"CellCallNumber");
    [self callNumber:self.seletedlawyer.mobile];
}
// 咨询
- (void)consult
{
    NSLog(@"Cellconsult");
}



// 另一个加载律师列表的接口，但好像没什么效果
- (void)loadlawyerlist
{
  
    __weak  DetailLawfirmViewController * weakSelf = self;
    [[LBSDataCenter defaultCenter] loadDataWithNearby:self.lawfirm.coordinate radius:20000 searchtype:searchLawyer searchKye:self.lawfirm.name index:currentIndex     pageSize:pageSize pieceComplete:^(LBSRequest *request, NSDictionary *dataModel) {
        if (dataModel)
		{
            LBSLawyer *lawyer = [[LBSLawyer alloc]initWithDataModel:dataModel];
            [weakSelf.muarLawyerlist addObject:lawyer];
            
        }
		else
		{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"reload data now.");
				totalItemCount = request.availableItemCount;
				NSLog(@"total:%d, loaded:%d", totalItemCount, [weakSelf.muarLawyerlist count]);
				NSUInteger curCnt = [weakSelf.muarLawyerlist count];
				if (curCnt >= totalItemCount)
					_noMoreResultsAvail = YES;
                
				if (request.error)
                {
                 [UIView hideHUDWithTitle:LBSUINetWorkError image:nil onView:weakSelf.view tag:ProHUD delay:1];
                }
                    //	[iToast make:LBSUINetWorkError duration:750];
             
            //    [self hideHUDWithTitle:LBSUINetWorkError image:nil delay:1];
               
				else if (request.availableItemCount)
                {
                    [UIView hideHUDWithTitle:LBSUIDataComplete image:nil onView:weakSelf.view tag:ProHUD delay:1];
                }
					
                // [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:1];
                
				else
                {
                    [UIView hideHUDWithTitle:LBSUINoMoreData image:nil onView:weakSelf.view tag:ProHUD delay:1];
                }
               //  [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:1];
				[weakSelf.tableView reloadData];
            });
        }
    }];

}

// 打电话
#pragma mark - callNumber

- (void)callNumber:(NSString *)number
{
    if (number.length > 0)
    {
        if ([[Network sharedNetwork]isRightMobile:number]) {
            BOOL success = [ACETelPrompt callPhoneNumber:number
                                                    call:^(NSTimeInterval duration) {
                                                    }
                            
                                                  cancel:^{
                                                      
                                                  }];
            if (!success)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码无效，拨打失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码为空，拨打失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark - Present message compose view controller

- (void)presentMessageComposeViewControllerWithNumber:(NSString *)number
{
    if (number.length > 0) {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil)
        {
            if ([MFMessageComposeViewController canSendText])
            {
                
                MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
                vc.messageComposeDelegate = self;
                NSArray * array = @[number];
                vc.recipients = array;
                // vc.body =@"";
                [self.parentViewController presentViewController:vc animated:YES completion:nil];
                
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉！该设备不支持发送短信的功能" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码为空!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}



#pragma mark - UITableViewDatasource And UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.muarLawyerlist.count;
}



- (void)configureLawyerCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //显示本所律师列表中的每一个律师数据
    LawyerCell *lycell = (LawyerCell *)cell;
    lycell.cellindexPath = indexPath;
    LBSLawyer *lawyer = [self.muarLawyerlist objectAtIndex:indexPath.row];
    lycell.lbName.text = lawyer.name;
    lycell.lblawfirm.text = lawyer.lawfirmName;
    lycell.lbCertificate.text = lawyer.certificateNo;
    lycell.specialAreaStr = lawyer.specialArea;
    
    [lycell.imgIntroduct setImageWithURL:lawyer.mainImageURL placeholderImage:[UIImage imageNamed:@"defaultlawyer"]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 140;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LawyerCell"];
    [self configureLawyerCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.seletedlawyer = [self.muarLawyerlist objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"DetailfirmToDetailLawyer" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kHeardHeight;
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kHeardHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, kHeardHeight)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont boldSystemFontOfSize:15];
    // lable.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:255.0/255.0 alpha:1];
    [view addSubview:lable];
    lable.text = [NSString stringWithFormat:@"  本所律师列表"];
    return view;
}



# pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeSignalObserver];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 进入地图界面
    if ([segue.identifier isEqualToString:@"Detaillawfirm_lawyertoDetailLawfirmLocation"]) {
        UINavigationController * navVC = segue.destinationViewController;
        DetailLocationViewController *vc = (DetailLocationViewController *)[navVC.viewControllers lastObject];
        vc.locationType = searchLawyer;
        vc.LBSLocation = self.seletedlawyer;
    }
    
    else if ([segue.identifier isEqualToString:@"DetailfirmToDetailLawyer"])//进入律师详情界面
    {
        DetailLawyerViewController *vc = (DetailLawyerViewController *)segue.destinationViewController;
        vc.lawyer = self.seletedlawyer;
    }

}


@end
