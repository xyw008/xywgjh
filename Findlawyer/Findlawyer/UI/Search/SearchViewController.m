//
//  SearchViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDeatalViewController.h"
#import "SearchLawyerViewController.h"
#import "SearchSortView.h"
#import "NITextField.h"
#import "ChooseTable.h"

#define kSortBetweenSpace 10

typedef enum
{
    SelectSortType_lawyer,//律师
    SelectSortType_lawfirm,//律所
}SelectSortType;


@interface SearchViewController ()<UISearchBarDelegate,UITextFieldDelegate>
{
    UIButton                    *_leftBtn;//左边选中btn
    
    UIScrollView                *_sortBgScrollView;//两个分类的背景视图
    SearchSortView              *_courtSortView;//法院分类
    SearchSortView              *_specialtySortView;//擅长分类
    
    SelectSortType              _sortType;//选中的种类
    
    UIView                      *_chooseBgView;//选择背景视图
    NITextField                 *searchTF;
    
}

@property (nonatomic,strong )NSArray *searchResults;
@property (nonatomic,strong)NSArray * staticSearchList;
@property (nonatomic,strong)NSString *chooseditem;
@property (nonatomic) SearchType searchtype;
@property (nonatomic,strong) NSString *searchkey;
@property (strong,nonatomic)UIButton * btnNearLawFirm;
@property (strong,nonatomic)UIButton * btnNearLawyer;


@end

@implementation SearchViewController
{
    BMKCloudSearch* _search;  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ATColorRGBMake(223, 223, 223);
    
    _sortType = SelectSortType_lawyer;
    
    self.staticSearchList = @[@{@"Item":@"     周边律所",@"ItemValue": @[]},
                              @{@"Item":@"     附近律师",@"ItemValue": @[]},
                              @{@"Item":@"     法院周边",@"ItemValue": @[@"xcode中级法院",@"福田区法院",@"罗湖区法院",@"南山区法院",@"宝安区法院",@"更多"]},
                              @{@"Item":@"     擅长领域",@"ItemValue":@[@"刑事",@"刑事辩护",@"公司",@"经济合同",@"民商经济",@"房地产",@"更多"]}];
//    self.searchDisplayController.searchBar.delegate = self;
//    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor clearColor];
    
    [self initTopBar];
    [self initScrollViewAndCourtSortView];
    [self initSpecialtySortView];
    
    
};

#pragma mark - init method
- (void)initTopBar
{
    
    //用于改变 searchTopBarBgView 的位置
    UIView *hiddenView = [[UIView alloc] initWithFrame:CGRectMake(0, 22, 1, 40)];
    hiddenView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *hidden = [[UIBarButtonItem alloc] initWithCustomView:hiddenView];
    self.navigationItem.leftBarButtonItem = hidden;
    
    //bg view
    UIView *searchTopBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 29)];
    searchTopBarBgView.backgroundColor = [UIColor clearColor];
    
    //背景图
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 28.5)];
    bgIV.image = [UIImage imageNamed:@"Search_topBar_bg"];
    bgIV.alpha = 0.5;
    [searchTopBarBgView addSubview:bgIV];
    
    CGFloat sideSpace = 10;
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(sideSpace, 0, 55, 28);
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 34, 0, -36);
    _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(2, -30, 0, 0);
//    _leftBtn.titleLabel.font = SP16Font;
    [_leftBtn setTitle:@"律师" forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"Search_top_arrow"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(selectSearchSort:) forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [searchTopBarBgView addSubview:_leftBtn];
    
    //分割线
    UIView *segmentLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftBtn.frame), .5, .5, bgIV.height - .5)];
    segmentLine.backgroundColor = [UIColor whiteColor];
    [searchTopBarBgView addSubview:segmentLine];
    
    CGFloat tfX = CGRectGetMaxX(segmentLine.frame) + 2;
    searchTF = [[NITextField alloc] initWithFrame:CGRectMake(tfX, 0, searchTopBarBgView.width - tfX - sideSpace, bgIV.height)];
    searchTF.delegate = self;
    searchTF.backgroundColor = [UIColor clearColor];
    searchTF.textColor = [UIColor whiteColor];
    searchTF.placeholder = @"请输入名称";
    searchTF.placeholderTextColor = [UIColor whiteColor];
    searchTF.font = _leftBtn.titleLabel.font;
    searchTF.placeholderFont = _leftBtn.titleLabel.font;
    searchTF.returnKeyType = UIReturnKeySearch;
    [searchTopBarBgView addSubview:searchTF];
    
    //右边取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 22, 40, 40);
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = _leftBtn.titleLabel.font;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    self.navigationItem.titleView = searchTopBarBgView;
    
//    [self.navigationController.navigationBar setBarTintColor:ATColorRGBMake(1, 122, 255)];
}

- (void)initScrollViewAndCourtSortView
{
    _sortBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [_sortBgScrollView keepAutoresizingInFull];
    [self.view addSubview:_sortBgScrollView];
    
    _courtSortView = [[SearchSortView alloc] initWithFrame:CGRectMake(kSortBetweenSpace, 4, _sortBgScrollView.width - kSortBetweenSpace*2, 10) title:@"法院周边" sortNameArray:[self getLawfirmArray]];
    _courtSortView.delegate = self;
    [_sortBgScrollView addSubview:_courtSortView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_courtSortView.frame), self.view.width, 1)];
    lineView.backgroundColor = ATColorRGBMake(199, 198, 198);
    [_sortBgScrollView addSubview:lineView];
}

- (void)initSpecialtySortView
{
    _specialtySortView = [[SearchSortView alloc] initWithFrame:CGRectMake(kSortBetweenSpace, CGRectGetMaxY(_courtSortView.frame) + 2, _sortBgScrollView.width - kSortBetweenSpace*2, 10) title:@"擅长领域" sortNameArray:kSpecialtyDomainArray];
    _specialtySortView.delegate = self;
    [_sortBgScrollView addSubview:_specialtySortView];
    _sortBgScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_specialtySortView.frame));
}

#pragma mark - get data soucre

/*
 指定周边 的经纬度
 
 福田区人民法院  114.060687, 22.526431
 南山区人民法院  113.938349, 22.552192
 罗湖区人民法院  114.152211, 22.56198
 盐田区人民法院  114.24362, 22.563674
 宝安区人民法院  113.91767, 22.562314
 龙岗区人民法院  114.24941, 22.725061
 深圳市中级人民法院  114.073383, 22.565234
 
 市民中心  114.066122, 22.548637
 招商银行大厦  114.028946, 22.54308
 赛格广场  114.094122, 22.547269
 地王大厦  114.117076, 22.548921
 国贸大厦  114.126176, 22.546843
 海岸城  113.943485, 22.522769
 */

- (NSArray*)getLawfirmArray
{
    return @[@"福田区法院",@"南山区法院",@"罗湖区法院",@"盐田区法院",@"宝安区法院",@"龙岗区法院",@"深圳市中级法院",@"市民中心",@"招商银行大厦",@"赛格广场",@"地王大厦",@"国贸大厦",@"海岸城"];
}

/**
 *  获取给定地点的坐标（经度、纬度）
 *
 *  @param lawfirmName 法院or指定地点的名字（key）
 *
 *  @return 指定地点的CLLocationCoordinate2D
 */
- (CLLocationCoordinate2D)getLawfirmLocationCoordinate2D:(NSString*)lawfirmName
{
    NSDictionary *allCoordinateDic = @{@"福田区法院":@[@114.060687, @22.526431],
                                       @"南山区法院":@[@113.938349, @22.552192],
                                       @"罗湖区法院":@[@114.152211, @22.56198],
                                       @"盐田区法院":@[@114.24362, @22.563674],
                                       @"宝安区法院":@[@113.91767, @22.562314],
                                       @"龙岗区法院":@[@114.24941, @22.725061],
                                       @"深圳市中级法院":@[@114.073383, @22.565234],
                                       
                                       @"市民中心":@[@114.066122, @22.548637],
                                       @"招商银行大厦":@[@114.028946, @22.54308],
                                       @"赛格广场":@[@114.094122, @22.547269],
                                       @"地王大厦":@[@114.117076, @22.548921],
                                       @"国贸大厦":@[@114.126176, @22.546843],
                                       @"海岸城":@[@113.943485, @22.522769]};
    if ([[allCoordinateDic allKeys] containsObject:lawfirmName])
    {
        NSArray *loaction = (NSArray*)[allCoordinateDic objectForKey:lawfirmName];
        
        //latitude是第二个，longitude是第一个,所以取值的时候先 index:1 再 index:0
        return CLLocationCoordinate2DMake([[loaction objectAtIndex:1] doubleValue], [[loaction objectAtIndex:0] doubleValue]);
    }
    return CLLocationCoordinate2DMake(22.526431, 114.060687);
}

#pragma mark - btn touch
/**
 *  选择是搜索 律师or律所
 *
 *  @param btn touchBtn
 */
- (void)selectSearchSort:(UIButton*)btn
{
    if (!_chooseBgView) {
        _chooseBgView = [[UIView alloc] initWithFrame:self.view.bounds];
        _chooseBgView.backgroundColor = [UIColor clearColor];
        ChooseTable *chooseTable = [ChooseTable loadFromNib];
        chooseTable.frameOriginX = IPHONE_WIDTH > 320 ? 65 * IPHONE_WIDTH / 320 : 30 ;
        chooseTable.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideChooseBgView:)];
        [_chooseBgView addGestureRecognizer:tap];
        [_chooseBgView addSubview:chooseTable];
        [self.view addSubview:_chooseBgView];
    }
    _chooseBgView.hidden = NO;
}

/**
 *  取消btn touch
 *
 *  @param btn
 */
- (void)cancelBtnTouch:(UIButton*)btn
{
    searchTF.text = nil;
    [searchTF resignFirstResponder];
    self.tabBarController.selectedIndex = 0;
}

/**
 *  点击背景隐藏choose view
 *
 *  @param gesture 点击手势
 */
- (void)hideChooseBgView:(UITapGestureRecognizer*)gesture
{
    _chooseBgView.hidden = YES;
}



// 快速搜索周边律所 和附近律师
- (void)ChooseSearchDetail:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        self.searchtype = SearchHouse;
        self.searchkey =@"";
        self.chooseditem = @"周边律所";
        [self pushToSeachDetailView];
    }
    else if(btn.tag == 1)
    {
        self.chooseditem = @"附近律师";
        self.searchtype = searchLawyer;
        self.searchkey =@"";
        [self pushToSeachDetailView];
    }
}

// 搜索具体搜索项
- (void)pushToSeachDetailView
{
    if (self.searchtype == SearchHouse)
    {
        [self performSegueWithIdentifier:@"toSearchDetailLawfirm" sender:self];//搜索律所
    }
    else
    {
        [self performSegueWithIdentifier:@"toSearchDetailLawyer" sender:self]; // 搜索律师
    }
}

#pragma mark - SearchSortView delegate

/**
 *  点击分类按钮触发时间处理
 *
 *  @param view  SearchSortView
 *  @param index 点击的index
 */
- (void)SearchSortView:(SearchSortView*)view didTouchIndex:(NSInteger)index didBtnTitle:(NSString*)title
{
    //法院周边
    if ([view isEqual:_courtSortView])
    {
//        [self pushSearchLawyerVCWithSearchKey:title hasCoordinate:YES];
        [self pushSearchLawyerVCWithSearchKey:title hiddenSearchKey:NO hasCoordinate:YES];
    }
    //擅长领域
    else if ([view isEqual:_specialtySortView])
    {
        [self pushSearchLawyerVCWithSearchKey:title hiddenSearchKey:YES hasCoordinate:NO];
    }
}

#pragma mark - ChooseTable delegate
/**
 *  选中一个类型触发
 *
 *  @param view ChooseTableView
 *  @param index selectIndex
 */
- (void)ChooseTable:(ChooseTable*)view didSelectIndex:(NSInteger)index
{
    if (index > 1) {
        view.hidden = YES;
        return;
    }
    //改变选中的类型
    _sortType = index;
    [_leftBtn setTitle:index==0?@"律师":@"律所" forState:UIControlStateNormal];
    _chooseBgView.hidden = YES;
    
    //改变scrollView contentSize 和 隐藏_specialtySortView
//    CGFloat maxY = index==0 ? CGRectGetMaxY(_specialtySortView.frame):CGRectGetMaxY(_courtSortView.frame);
//    _sortBgScrollView.contentSize = CGSizeMake(0, maxY);
//    _specialtySortView.hidden = index==0?NO:YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchTF resignFirstResponder];
    
    if (textField.text.length < 1)
    {
        [self showHUDInfoByString:@"请输入搜索名称"];
    }
    else
    {
        if (_sortType == SelectSortType_lawyer)//搜索律师
        {
//            [self pushSearchLawyerVCWithSearchKey:textField.text hiddenSearchKey:NO];
            [self pushSearchLawyerVCWithSearchKey:textField.text hiddenSearchKey:NO hasCoordinate:NO];
        }
        else if (_sortType == SelectSortType_lawfirm)//搜索律所
        {
//            [self pushSearchDeatalVCWithSearchKey:textField.text hasCoordinate:NO];
            [self pushSearchDeatalVCWithSearchKey:textField.text];
        }
    }
    if (_chooseBgView)
    {
        _chooseBgView.hidden = YES;
    }
    
    return YES;
}


#pragma mark - push method
//指定坐标
- (void)pushSearchDeatalVCWithSearchKey:(NSString*)key
{
    SearchDeatalViewController *vc = [[SearchDeatalViewController alloc] init];
    vc.strTitle = @"附件律所";
    vc.isShowMapView = YES;
    vc.searchKey = key;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    SearchLawyerViewController *vc = [[SearchLawyerViewController alloc] init];
    vc.strTitle = @"附近律师";
    vc.isShowMapView = YES;
    if (hasCoordinate)
    {
        vc.searchLocation = [self getLawfirmLocationCoordinate2D:key];
    }
    else
    {
        vc.searchKey = key;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
     */
}

/**
 *  进入律师搜索页面
 *
 *  @param key           搜索的key
 *  @param hidden        是否在下个视图隐藏搜索的key
 *  @param hasCoordinate 是否已经有指定坐标
 */
- (void)pushSearchLawyerVCWithSearchKey:(NSString*)key hiddenSearchKey:(BOOL)hidden hasCoordinate:(BOOL)hasCoordinate
{
//    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //        SearchLawyerViewController *vc = (SearchLawyerViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchDetailLawyer"];
    SearchLawyerViewController *vc = [[SearchLawyerViewController alloc] init];
    vc.strTitle = @"附近律师";
    vc.isShowMapView = YES;
    vc.isHiddenSearchKey = hidden;
    if (hasCoordinate)
    {
        vc.searchLocation = [self getLawfirmLocationCoordinate2D:key];
    }
    else
    {
        vc.searchKey = key;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDatasource And UITableViewDelegate



#pragma mark - Search display controller delegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
     NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    if (selectedScopeButtonIndex == 0)
    {
        //  scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师事务所名称";
    }
    else
    {
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师";
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.placeholder = @"搜索";
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
//    NSString *searchString = [self.searchDisplayController.searchBar text];
//    NSString *scope;
    
   // NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    if (searchOption == 0)
    {
      //  scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师事务所名称";
    }
    else
    {
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师";

    }
   // [self.searchResults removeAllObjects];
    
     return NO;
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;
{

   // [self performSegueWithIdentifier:@"toSearchDetail" sender:self];

}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   
    NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    if (selectedScopeButtonIndex == 0)
    {
        self.searchResults = @[@"广东国晖律师事务所"];
        self.searchtype = SearchHouse;
        self.searchkey = self.searchDisplayController.searchBar.text;
        
    }
    else
    {
     
        self.searchResults = @[@"小强律师"];
        self.searchtype = searchLawyer;
        self.searchkey = self.searchkey = self.searchDisplayController.searchBar.text;

    }
  
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view]; // Hidden extra cell line.
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self pushToSeachDetailView];
    
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
    if ([segue.identifier isEqualToString:@"toSearchDetailLawfirm"])
    {
        SearchDeatalViewController * VC  = segue.destinationViewController;
        VC.strTitle = self.chooseditem;
        VC.searchKey = self.searchkey;
    }
    else if([segue.identifier isEqualToString:@"toSearchDetailLawyer"])
    {
       SearchLawyerViewController* VC  = segue.destinationViewController;
        VC.strTitle = self.chooseditem;
        VC.searchKey = self.searchkey;
    }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
