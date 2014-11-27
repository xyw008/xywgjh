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
#import "HUDManager.h"
#import "ConsultInfoVC.h"
#import "CallAndMessageManager.h"
#import "NIWebController.h"

#ifndef ProHUD
#define ProHUD	199
#endif

#define kTableCellDefaultHeight 30

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
    self.view.backgroundColor = HEXCOLOR(0XF5F5F5);
    
    self.arChooseItems = [[NSArray alloc]init];
    self.dicLoaed = [[NSMutableDictionary alloc]init];
  //  self.arArtiiclelist = [[NSArray alloc]init];
    
    ToolView *tempTool = [ToolView loadFromNib];
    
    //用来添加各种界面后
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - tempTool.height)];
    self.myScrollView.tag=4;
    self.myScrollView.backgroundColor=[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:(229.0/255.0) alpha:1];
    self.myScrollView.backgroundColor=[UIColor whiteColor];
    self.myScrollView.pagingEnabled=NO;
    self.myScrollView.showsVerticalScrollIndicator=YES;
    self.myScrollView.showsHorizontalScrollIndicator=NO;
    _myScrollView.contentSize = CGSizeMake(0, 0);
    [_myScrollView keepAutoresizingInFull];
    [self.view addSubview:self.myScrollView];
    
    self.myScrollView.userInteractionEnabled=YES;
    self.myScrollView.scrollEnabled=YES;
    self.title = self.lawyer.name;
    
    //显示咨询btn
    if (_showConsultBtn)
        [self initConsultBtn];
    else
        [self configToolview];
    
    [self loadLawyerInfo];
   // [self.myScrollView setContentSize:CGSizeMake(320.0,630)];

    // Do any additional setup after loading the view.
}

- (void)loadLawyerInfo
{
    __weak DetailLawyerViewController *weakSelf = self;
    NetReturnType ret = [[Network sharedNetwork]loadlawyerInfoWithID:[self.lawyer.lawerid integerValue] completion:^(NSInteger result, NSString *message, NSDictionary * userInfo) {
        
        STRONGSELF
        if (result)
        {
            if (userInfo)
            {
                NSArray * contents = userInfo[@"Lawyer"];
                NSDictionary * dic = [contents objectAtIndex:0];
//                weakSelf.lawyer.tel = dic[@"Tel"];
                weakSelf.lawyer.fax = dic [@"Fax"];
                weakSelf.lawyer.address = dic [@"Address"];
                weakSelf.lawyer.detail = dic [@"Detail"];
                weakSelf.lawyer.mailBox = dic [@"Mail"];
                weakSelf.lawyer.mobile = dic [@"Mobile"];
                [weakSelf configHeaderView];
                
                if (strongSelf->_showConsultBtn)
                    [strongSelf initConsultBtn];
                else
                    [strongSelf configToolview];
                
//                [weakSelf configToolview];
            }
            else
            {
//                [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
//                [HUDManager showAutoHideHUDWithToShowStr:@"加载完毕" HUDMode:MBProgressHUDModeText];
            }
        }
        else
        {
//           [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
//           [HUDManager showAutoHideHUDWithToShowStr:@"加载完毕" HUDMode:MBProgressHUDModeText];
        }
    }];
                         
    if ( ret == NetBeginRequest)
    {
//       [UIView showHUDWithTitle:@"加载中..." onView:self.view tag:ProHUD];
        
        [HUDManager showHUDWithToShowStr:@"加载中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
    }
    else if  ( ret == NetworkDisenable)
    {
//        [UIView  showHUDWithTitle:@"网络不给力！" image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
        [HUDManager showAutoHideHUDWithToShowStr:LBSUINetWorkError HUDMode:MBProgressHUDModeText];
    }
    else
    {
//        [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
        [HUDManager showAutoHideHUDWithToShowStr:@"加载失败..." HUDMode:MBProgressHUDModeText];
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
//                    [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
//                    [HUDManager showAutoHideHUDWithToShowStr:@"加载完毕" HUDMode:MBProgressHUDModeText];
                }
      
            }
            else
            {
//                [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
//                [HUDManager showAutoHideHUDWithToShowStr:@"加载完毕" HUDMode:MBProgressHUDModeText];
            }

        }
        else
        {
//            [UIView hideHUDWithTitle:@"加载失败..." image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
            [HUDManager showAutoHideHUDWithToShowStr:@"加载失败..." HUDMode:MBProgressHUDModeText];
        }
    }];
    if ( ret == NetBeginRequest)
    {
        
    }
    else if  ( ret == NetworkDisenable)
    {
       
//         [UIView hideHUDWithTitle:@"网络不给力！" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
        [HUDManager showAutoHideHUDWithToShowStr:LBSUINetWorkError HUDMode:MBProgressHUDModeText];
    }
    else
    {
       // [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
//        [UIView hideHUDWithTitle:@"加载失败..." image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
        [HUDManager showAutoHideHUDWithToShowStr:@"加载失败..." HUDMode:MBProgressHUDModeText];
    }
}

- (void)loadarticlistByID
{
    
    NSDictionary *dic = [self.arChooseItems objectAtIndex:self.choosedIndex];
    NSInteger typeid = [dic[@"NTypeId"] integerValue];
    NSString * strType= dic[@"NTname"];

    __weak DetailLawyerViewController *weakSelf = self;
  
    NetReturnType ret =[[Network sharedNetwork] loadArticleListWithLawyerID:[self.lawyer.lawerid integerValue] typeID:typeid completion:^(NSInteger result, NSString *message, id userInfo) {
        
//        [UIView hideHUDWithTitle:@"加载完毕" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
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
//        [UIView hideHUDWithTitle:@"网络不给力！" image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
        
        [HUDManager showAutoHideHUDWithToShowStr:LBSUINetWorkError HUDMode:MBProgressHUDModeText];

    }
    else
    {
      //  [UIView  showHUDWithTitle:@"加载失败..." image:nil onView:self.view tag:ProHUD autoHideAfterDelay:1];
//         [UIView hideHUDWithTitle:@"加载完毕..." image:nil onView:weakSelf.view tag:ProHUD delay:0.5];
    }

    
}


#pragma mark - config all sub view
//配置律师页面的最上面部分的各种信息
- (void)configHeaderView
{
    _headerview = [DetailLawyerHeaderView loadFromNib];
    _headerview.width = _myScrollView.width;
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
    self.segmentcontrol.frame = CGRectMake(0, CGRectGetMaxY(self.headerview.frame), self.view.width, 25);
    _segmentcontrol.layer.borderColor = CellSeparatorColor.CGColor;
    _segmentcontrol.layer.borderWidth = 0.5;
    _segmentcontrol.tintColor = HEXCOLOR(0XF5F5F5);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:14],NSFontAttributeName ,nil];
    NSDictionary *dicSelect = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,nil];
    [_segmentcontrol setTitleTextAttributes:dic forState:UIControlStateNormal];
    [_segmentcontrol setTitleTextAttributes:dicSelect forState:UIControlStateSelected];
    
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
    if (self.tableView)
    {
//        self.tableView.frame =CGRectMake(0, CGRectGetMaxY(self.segmentcontrol.frame), _myScrollView.width, self.arArtiiclelist.count * kTableCellDefaultHeight);
        
        _tableView.height = self.arArtiiclelist.count * kTableCellDefaultHeight;
        [self.tableView reloadData];
    }
    else
    {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(_segmentcontrol.frameOriginX, CGRectGetMaxY(self.segmentcontrol.frame), _segmentcontrol.width, self.arArtiiclelist.count * kTableCellDefaultHeight) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.myScrollView addSubview:self.tableView];
    }
    self.myScrollView.contentSize = CGSizeMake(self.view.width, self.headerview.height + 10 +self.segmentcontrol.height + _tableView.contentSize.height +10);;
   
}
// 配置下面的工具界面 包括联系电话 ，在线咨询，打电话，发短信
- (void)configToolview
{
    _toolview = [ToolView loadFromNib];
    _toolview.frame = CGRectMake(0, CGRectGetMaxY(_myScrollView.frame), self.view.width, _toolview.height);
//    [_toolview newToolLayout];
    [_toolview configViewWithPhone:self.lawyer.mobile];
    _toolview.delegate = self;
    [_toolview keepAutoresizingInFull];
    [self.view addSubview:_toolview];
}

- (void)initConsultBtn
{
    ToolView *tempTool = [ToolView loadFromNib];
    
    UIButton *consultBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_myScrollView.frame), self.view.width, tempTool.height)];
    consultBtn.backgroundColor = tempTool.backgroundColor;
    [consultBtn setTitle:@"向TA咨询" forState:UIControlStateNormal];
    [consultBtn addTarget:self action:@selector(consultBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    consultBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [consultBtn keepAutoresizingInFull];
    [self.view addSubview:consultBtn];
}

#pragma mark - Btn touch event

- (void)consultBtnTouch:(UIButton*)btn
{
    ConsultInfoVC *vc = [[ConsultInfoVC alloc] init];
    vc.lawyerItem = _lawyer;
    [self pushViewController:vc];
}

//文章类型改变后，要根据ID加载文章列表
-(void)segmentChange:(UISegmentedControl *)Seg
{
    if (self.choosedIndex == Seg.selectedSegmentIndex) {
        return;
    }
    self.choosedIndex = Seg.selectedSegmentIndex;
    [self loadarticlistByID];
}


// 打电话
#pragma mark - callNumber And consult

- (void)callNumber:(NSString *)number
{
    [CallAndMessageManager callNumber:number call:^(NSTimeInterval duration) {
        
    } callCancel:^{
        
    }];
    
//    if (number.length > 0)
//    {
//        if ([[Network sharedNetwork]isRightMobile:number])
//        {
//            BOOL success = [ACETelPrompt callPhoneNumber:number
//                                                    call:^(NSTimeInterval duration) {
//                                                    }
//                            
//                                                  cancel:^{
//                                                      
//                                                  }];
//            if (!success)
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码无效，拨打失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//
//        }
//        else{
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//            [alert show];
//    
//        }
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码为空，拨打失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//    }

}

- (void)conusult
{

}
// 发短信
#pragma mark - Present message compose view controller

- (void)presentMessageComposeViewControllerWithNumber:(NSString *)number
{
    [CallAndMessageManager sendMessageNumber:number resultBlock:^(MessageSendResultType type) {
        
    }];
//    if (number.length > 0) {
//        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//        if (messageClass != nil)
//        {
//            if ([MFMessageComposeViewController canSendText])
//            {
//                
//                MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
//                vc.messageComposeDelegate = self;
//                NSArray * array = @[number];
//                vc.recipients = array;
//                // vc.body =@"";
//                [self.parentViewController presentViewController:vc animated:YES completion:nil];
//                
//                
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉！该设备不支持发送短信的功能" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码为空!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//    }
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

- (void)ToolView:(ToolView *)view didBtnType:(ToolBtnTouchType)type
{
    switch (type)
    {
        case ToolBtnTouchType_Consult:
        {
            [self consultBtnTouch:nil];
        }
            break;
        case ToolBtnTouchType_Call:
            [self callNumber:self.lawyer.mobile];
            break;
        case ToolBtnTouchType_Sms:
            [self presentMessageComposeViewControllerWithNumber:self.lawyer.mobile];
            break;
        default:
            break;
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
    
    return kTableCellDefaultHeight;
    
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
//        CGFloat startX = 4;
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(startX, kTableCellDefaultHeight - .5, cell.width - startX*2, .5)];
//        line.backgroundColor = CellSeparatorColor;
//        [cell.contentView addSubview:line];
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
    
//    LawyerArticleViewController *vc = [[LawyerArticleViewController alloc] init];
//    vc.dicArticle = _seletedArticle;
//    [self pushViewController:vc];
//    [self performSegueWithIdentifier:@"LawyerToArticle" sender:self];
    NSString *articleId = [_seletedArticle objectForKey:@"Id"];
    if (articleId)
    {
        NSString *urlStr = [NSString stringWithFormat:@"http://test3.sunlawyers.com/news.aspx?id=%@&islawyer=%d",articleId,[_lawyer.lawerid integerValue]];
        NIWebController *web = [[NIWebController alloc] initWithURL:[NSURL URLWithString:urlStr]];
        web.toolbarHidden = YES;
        [self pushViewController:web];
    }
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
