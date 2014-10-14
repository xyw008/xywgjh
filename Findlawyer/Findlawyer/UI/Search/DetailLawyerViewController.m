//
//  DetailLawyerViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-8-22.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "DetailLawyerViewController.h"
#import "DetailLawyerHeaderView.h"
#import "LawyerCell.h"
#import "LBSLawyer.h"
#import "Network.h"
#import "UIView+ProgressHUD.h"
#import "LawyerArticle.h"
#import "LawyerArticleViewController.h"
#import <MessageUI/MessageUI.h>
#import "ACETelPrompt.h"


#ifndef ProHUD
#define ProHUD	199
#endif

@interface DetailLawyerViewController ()<UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic,strong)DetailLawyerHeaderView * headerview;
@property (nonatomic,strong)NSArray * arChooseItems;
@property (nonatomic )NSInteger choosedIndex;
@property (nonatomic,strong)NSArray  *arArtiiclelist;
@property (nonatomic,strong)NSMutableDictionary  * dicLoaed ;
@property (nonatomic,strong)NSDictionary * seletedArticle;
@property (nonatomic,strong)ToolView *toolview;


@end

@implementation DetailLawyerViewController

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
    self.arChooseItems = [[NSArray alloc]init];
    self.dicLoaed = [[NSMutableDictionary alloc]init];
  //  self.arArtiiclelist = [[NSArray alloc]init];
    
    CGFloat statusBarHigh = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat high = [UIScreen mainScreen].bounds.size.height - statusBarHigh - navBarHigh-40;
    
    //用来添加各种界面后
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, high)];
    self.myScrollView.tag=4;
    self.myScrollView.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:(229.0/255.0) alpha:1];
    self.myScrollView.backgroundColor=[UIColor whiteColor];
    self.myScrollView.pagingEnabled=NO;
    self.myScrollView.showsVerticalScrollIndicator=YES;
    self.myScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.myScrollView];
    
    self.myScrollView.userInteractionEnabled=YES;
    self.myScrollView.scrollEnabled=YES;
    self.title = self.lawyer.name;

    [self loadLawyerInfo];
   // [self.myScrollView setContentSize:CGSizeMake(320.0,630)];

    // Do any additional setup after loading the view.
}

- (void)loadLawyerInfo
{
    __weak DetailLawyerViewController *weakSelf = self;
    NetReturnType ret = [[Network sharedNetwork]loadlawyerInfoWithID:[self.lawyer.lawerid integerValue] completion:^(NSInteger result, NSString *message, NSDictionary * userInfo) {
        if (result) {
            if (userInfo)
            {
                NSArray * contents = userInfo[@"Lawyer"];
                NSDictionary * dic = [contents objectAtIndex:0];
                weakSelf.lawyer.tel = dic[@"Tel"];
                weakSelf.lawyer.fax = dic [@"Fax"];
                weakSelf.lawyer.address = dic [@"Address"];
                weakSelf.lawyer.detail = dic [@"Detail"];
                weakSelf.lawyer.mailBox = dic [@"Mail"];
                weakSelf.lawyer.mobile = dic [@"Mobile"];
                [weakSelf configHeaderView];
                if (weakSelf.lawyer.mobile.length > 0) {
                    [weakSelf configToolview];
                }
            }
            else
            {
                [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
            }
        }

        else
        {
           [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
        }
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
- (void)loadArticlTypes
{
    __weak DetailLawyerViewController *weakSelf = self;
    
    NetReturnType ret =[[Network sharedNetwork]loadArticleTypestWithID:[self.lawyer.lawerid integerValue]  completion:^(NSInteger result, NSString *message, NSDictionary * userInfo)
    {
        if (result) {
            
            if (userInfo) {
                
                weakSelf.arChooseItems = userInfo[@"NewsType"];
                
                if (weakSelf.arChooseItems.count >0)
                {
                    for (NSDictionary * dic in weakSelf.arChooseItems)
                    {
                        NSString *strtype = dic [@"NTname"];
                        self.dicLoaed [strtype] = @(NO);
                    }
                    
                    [weakSelf configSegmentcontrol];
                }
                else
                {
                    [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
                }
      
            }
            else
            {
                [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
            }

        }
        else
        {
            [UIView hideHUDWithTitle:@"加载失败..." image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
        }
    }];
    if ( ret == NetBeginRequest)
    {
        
    }
    else if  ( ret == NetworkDisenable)
    {
       
         [UIView hideHUDWithTitle:@"网络不给力！" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
    }
    else
    {
       // [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
        [UIView hideHUDWithTitle:@"加载失败..." image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
    }
}

- (void)loadarticlistByID
{
    
    NSDictionary *dic = [self.arChooseItems objectAtIndex:self.choosedIndex];
    NSInteger typeid = [dic[@"NTypeId"] integerValue];
    NSString * strType= dic[@"NTname"];

    __weak DetailLawyerViewController *weakSelf = self;
  
    NetReturnType ret =[[Network sharedNetwork] loadArticleListWithLawyerID:[self.lawyer.lawerid integerValue] typeID:typeid completion:^(NSInteger result, NSString *message, id userInfo) {
        
        [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
        if (userInfo)
        {
            weakSelf.dicLoaed[strType]= @(YES);
            weakSelf.arArtiiclelist = userInfo[@"News"];//userInfo[@"News"];
           [weakSelf configTableview];
           
        }
    }];
     if ( ret == NetBeginRequest)
    {
        
    }
    else if  ( ret == NetworkDisenable)
    {
        //[UIView  showHUDWithTitle:@"网络不给力！" image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
        [UIView hideHUDWithTitle:@"网络不给力！" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];

    }
    else
    {
      //  [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
         [UIView hideHUDWithTitle:@"加载完毕..." image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
    }

    
}

//配置律师页面的最上面部分的各种信息
- (void)configHeaderView
{
    self.headerview =[[[NSBundle mainBundle] loadNibNamed:@"DetailLawyerHeaderView" owner:self options:nil] lastObject];
    [self.headerview configViewWithmainImage:self.lawyer.mainImageURL certificateNum:self.lawyer.certificateNo lawfirmname:self.lawyer.lawfirmName specailarea:self.lawyer.specialArea detailInfo:self.lawyer.detail];
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width,CGRectGetMaxY(self.headerview.frame)+10);
    [self.myScrollView addSubview:self.headerview];
    [self loadArticlTypes];
}

//配置文章类型列表Segmtcontril
-(void)configSegmentcontrol
{
    NSMutableArray * muar = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dic in self.arChooseItems)
    {
        [muar addObject:dic [@"NTname"]];
    }
    CGSize contendsize = self.myScrollView.contentSize;
    contendsize = CGSizeMake(contendsize.width, contendsize.height +25 );
    self.myScrollView.contentSize = contendsize;
    self.segmentcontrol= [[UISegmentedControl alloc]initWithItems:muar];
    self.segmentcontrol.frame = CGRectMake(5, CGRectGetMaxY(self.headerview.frame), 310, 25);
    [self.segmentcontrol addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    self.segmentcontrol.selectedSegmentIndex = 0;
     self.choosedIndex = 0;
    
    [self.myScrollView addSubview:self.segmentcontrol];
    [self loadarticlistByID];
    
//    UIImageView * line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"separator"]];
//    line.frame = CGRectMake(0, CGRectGetHeight(self.bgSegmentcontrol.frame)-1, CGRectGetWidth(self.bgSegmentcontrol.frame), 1);
//    [self.bgSegmentcontrol addSubview:line];
    
}

//配置每一个文章类型下的文章列表
- (void)configTableview
{
    CGSize  contendsize = CGSizeMake(self.view.frame.size.width, self.headerview.frame.size.height + 10+self.segmentcontrol.frame.size.height +self.arArtiiclelist.count * 30 +10);
    self.myScrollView.contentSize = contendsize;
    
    if (self.tableView)
    {
       [self.tableView removeFromSuperview];
        self.tableView.frame =CGRectMake(0, CGRectGetMaxY(self.segmentcontrol.frame), CGRectGetWidth(self.view.frame), self.arArtiiclelist.count * 30);
        [self.myScrollView addSubview:self.tableView];
        [self.tableView reloadData];
    }
    else
    {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentcontrol.frame), CGRectGetWidth(self.view.frame), self.arArtiiclelist.count * 30) style:UITableViewStylePlain];
        self.tableView.tableFooterView = [[UIView alloc]init];
        self.tableView.dataSource = self;
        self.tableView.delegate  = self;
        [self.myScrollView addSubview:self.tableView];

    }
   
}
// 配置下面的工具界面 包括联系电话 ，在线咨询，打电话，发短信
- (void)configToolview
{
 
     self.toolview =[[[NSBundle mainBundle] loadNibNamed:@"ToolView" owner:self options:nil] lastObject];
    self.toolview.frame = CGRectMake(0, CGRectGetMaxY(self.myScrollView.frame), 320, 40);
    [self.toolview configViewWithPhone:self.lawyer.mobile];
    self.toolview.delegate = self;
    [self.view addSubview:self.toolview];
    
}


//文章类型改变后，要根据ID加载文章列表
-(void)segmentChange:(UISegmentedControl *)Seg
{
    self.choosedIndex = Seg.selectedSegmentIndex;
    [self loadarticlistByID];
}


// 打电话
#pragma mark - callNumber And consult

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

- (void)conusult
{

}
// 发短信
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

#pragma mark - Message compose view controller delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
 
    if (result == MessageComposeResultCancelled)
    {
           }
    else if (result == MessageComposeResultSent)
    {
    }
    else
    {
    }
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - ToolViewDelegate

- (void)selectedToolView:(ToolView *)view btnTag:(NSInteger)btnTag
{
    NSLog(@"ToolViewDelegate!");
    if (btnTag ==0)
    {
       
    }
    else if (btnTag ==1)
    {
      [self callNumber:self.lawyer.mobile];
    }
    else if (btnTag ==2)
    {
       [self presentMessageComposeViewControllerWithNumber:self.lawyer.mobile];
    }
}

#pragma mark - UITableViewDatasource And UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arArtiiclelist.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 30;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:TableSampleIdentifier];
    }

    
    NSDictionary * dic = [self.arArtiiclelist objectAtIndex:indexPath.row];
    cell.textLabel.text = dic[@"Title"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.text = dic [@"DateTime"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.seletedArticle = [self.arArtiiclelist objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"LawyerToArticle" sender:self];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //进入律师文章界面
    if ([segue.identifier isEqualToString:@"LawyerToArticle"]) {
        LawyerArticleViewController * articleVC = segue.destinationViewController;
        articleVC.dicArticle = self.seletedArticle;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
