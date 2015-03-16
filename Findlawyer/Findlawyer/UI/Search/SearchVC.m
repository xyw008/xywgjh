//
//  SearchVC.m
//  Find lawyer
//
//  Created by 龚 俊慧 on 15/1/14.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "SearchVC.h"
#import "SearchItemCollectionCell.h"
#import "SearchCollectionHeaderView.h"
#import "SearchCollectionFooterView.h"
#import "SearchLawyerViewController.h"
#import "SearchDeatalViewController.h"
#import "NITextField.h"
#import "KxMenu.h"

#define kNoLimitStr         @"不限"

#define kSearchTypeLawyer   @"律师"
#define kSearchTypeLawfirm  @"律师事务所"

static NSString * const cellIdentifier_collecitonViewCell   = @"cellIdentifier_collecitonViewCell";
static NSString * const cellIdentifier_collecitonViewHeader = @"cellIdentifier_collecitonViewHeader";
static NSString * const cellIdentifier_collecitonViewFooter = @"cellIdentifier_collecitonViewFooter";

typedef NS_ENUM(NSInteger, TheSearchType)
{
    /// 律师
    TheSearchType_lawyer = 0,
    /// 律所
    TheSearchType_lawfirm,
};

@interface SearchVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{
    NSArray          *_searchShowDataArray;
    
    UICollectionView *_collectionView;
    
    UIButton         *_searchTypeBtn;
    NITextField      *_serachTextField;
    TheSearchType    _searchType;
    
    NSArray          *_selectPathsArray;
}

@end

@implementation SearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getLocalShowData];
    [self initialization];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"内容定制"];
}

- (void)getLocalShowData
{
    _searchShowDataArray = @[[self getLawfirmArray], kSpecialtyDomainArray];
}

- (void)initialization
{
    // collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [SearchItemCollectionCell getCellSize];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView setAllowsMultipleSelection:YES];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView keepAutoresizingInFull];
    
    NSIndexPath *onePath = [NSIndexPath indexPathForItem:0 inSection:0];
    NSIndexPath *twoPath = [NSIndexPath indexPathForItem:0 inSection:1];
    _selectPathsArray = [[NSArray alloc] initWithObjects:onePath,twoPath, nil];
    
    [_collectionView selectItemAtIndexPath:onePath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [_collectionView selectItemAtIndexPath:twoPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchItemCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifier_collecitonViewCell];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchCollectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier_collecitonViewHeader];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchCollectionFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cellIdentifier_collecitonViewFooter];
    
    [self.view addSubview:_collectionView];
    
    // search bar
    [self configureNavSearchBar];
}

- (void)configureNavSearchBar
{
    UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fabao"]];
    imgview.contentMode = UIViewContentModeCenter;
    imgview.boundsWidth += 10;
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:imgview];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    // bg view
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 40 * 2, self.navigationController.navigationBar.boundsHeight - 8 * 2)];
    titleView.backgroundColor = HEXCOLOR(0X1481CA);
    [titleView setRadius:5];
    
    // 搜索类型btn
    _searchTypeBtn = InsertImageButtonWithTitle(titleView,
                       CGRectMake(0, 0, 50, titleView.boundsHeight),
                       1000,
                       nil,
                       nil,
                       @"律师",
                       UIEdgeInsetsMake(0, -32, 0, 0),
                       SP14Font,
                       [UIColor whiteColor],
                       self,
                       @selector(clickSearchType:));
    [_searchTypeBtn setImage:[UIImage imageNamed:@"xialajiantou"] forState:UIControlStateNormal];
    _searchTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 31, 0, 0);
    _searchType = TheSearchType_lawyer;
    
    // 搜索框
    _serachTextField = [[NITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_searchTypeBtn.frame), 0, titleView.boundsWidth - CGRectGetMaxX(_searchTypeBtn.frame), titleView.boundsHeight)];
    _serachTextField.delegate = self;
    _serachTextField.font = SP14Font;
    _serachTextField.placeholderTextColor = [UIColor whiteColor];
    _serachTextField.textColor = [UIColor whiteColor];
    _serachTextField.returnKeyType = UIReturnKeySearch;
    _serachTextField.placeholder = @"请输入名称";
    [titleView addSubview:_serachTextField];
    
    /*
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), 0, searchBarBgView.boundsWidth - CGRectGetMaxX(leftBtn.frame), searchBarBgView.boundsHeight)];
    searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)];
    [searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, searchBarBgView.boundsHeight)] forState:UIControlStateNormal];
    // searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"请输入名称";
    
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    
    // Change search bar text color
    searchField.textColor = [UIColor redColor];
    
    // Change the search bar placeholder text color
    [searchField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    [searchBarBgView addSubview:searchBar];
     */
    
    // cancel button
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                            barButtonTitle:@"取消"
                                    action:@selector(clickNavCancelBtn:)];

    self.navigationItem.titleView = titleView;
}

- (void)clickSearchType:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:kSearchTypeLawyer
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:kSearchTypeLawfirm
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.alignment = NSTextAlignmentLeft;
    
    [KxMenu showMenuInView:self.navigationController.view
                  fromRect:CGRectMake(50, 0, 60, CGRectGetMaxY(self.navigationItem.titleView.frame) + 20)
                 menuItems:menuItems];
}

- (void)pushMenuItem:(KxMenuItem *)sender
{
    if ([sender.title isEqualToString:kSearchTypeLawyer])
    {
        _searchType = TheSearchType_lawyer;
        
        [_searchTypeBtn setTitle:kSearchTypeLawyer forState:UIControlStateNormal];
    }
    else
    {
        _searchType = TheSearchType_lawfirm;
        
        [_searchTypeBtn setTitle:@"律所" forState:UIControlStateNormal];
    }
    [_collectionView reloadData];
    for (NSIndexPath *path in _selectPathsArray)
    {
        [_collectionView selectItemAtIndexPath:path animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    switch (_searchType) {
        case TheSearchType_lawyer:
            return _searchShowDataArray.count;
            break;
        case TheSearchType_lawfirm:
            return _searchShowDataArray.count - 1;
        default:
            break;
    }
    return _searchShowDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = _searchShowDataArray[section];
    
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier_collecitonViewCell forIndexPath:indexPath];
    
    NSArray *array = _searchShowDataArray[indexPath.section];
    NSString *titleStr = array[indexPath.row];
    
    [cell setTitleStr:titleStr];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        SearchCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier_collecitonViewHeader forIndexPath:indexPath];
        view.selectorBtn.tag = indexPath.section;
        [view.selectorBtn addTarget:self
                             action:@selector(clickSectionSelectorBtn:)
                   forControlEvents:UIControlEventTouchUpInside];
        if (0 == indexPath.section)
        {
            view.titleLabel.text = @"法院或商圈周边";
        }
        else
        {
            view.titleLabel.text = @"擅长领域";
        }
        
        return view;
    }
    else
    {
        SearchCollectionFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cellIdentifier_collecitonViewFooter forIndexPath:indexPath];
        [view.searchBtn addTarget:self
                           action:@selector(clickSearchBtn:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return [SearchCollectionHeaderView getViewSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    NSInteger showSection = 1;
    switch (_searchType)
    {
        case TheSearchType_lawfirm:
            showSection = 0;
            break;
        default:
            break;
    }
    
    if (showSection == section)
    {
        return [SearchCollectionFooterView getViewSize];
    }
    return CGSizeZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *indexPaths = [collectionView indexPathsForSelectedItems];

    for (NSIndexPath *path in _selectPathsArray)
    {
        if (indexPath.section == path.section && indexPath.item == path.item)
        {
            return NO;
        }
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
    
    for (NSIndexPath *path in _selectPathsArray)
    {
        if (path.section == indexPath.section)
        {
            [collectionView deselectItemAtIndexPath:path animated:YES];
        }
    }
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    _selectPathsArray = [collectionView indexPathsForSelectedItems];
}

////////////////////////////////////////////////////////////////////////////////

- (void)clickSectionSelectorBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    NSInteger tag = sender.tag;
    
    if (0 == tag)
    {
        
    }
    else if (1 == tag)
    {
        
    }
}

- (void)clickSearchBtn:(UIButton *)sender
{
    NSArray *indexPaths = [_collectionView indexPathsForSelectedItems];

    SearchLawyerViewController *searchLawyer = [[SearchLawyerViewController alloc] init];
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        // 法院或商圈周边的选中项
        if (0 == indexPath.section)
        {
            NSString *selectedSearchKeyStr = [[self getLawfirmArray] objectAtIndex:indexPath.item];
            if (![selectedSearchKeyStr isEqualToString:kNoLimitStr])
            {
                CLLocationCoordinate2D location = [self getLawfirmLocationCoordinate2D:selectedSearchKeyStr];
                
                searchLawyer.searchLocation = location;
            }
        }
        // 擅长领域的选中项
        else if (1 == indexPath.section)
        {
            NSString *selectedSearchKeyStr = kSpecialtyDomainArray[indexPath.item];
            
            searchLawyer.searchKey = ![selectedSearchKeyStr isEqualToString:kNoLimitStr] ? selectedSearchKeyStr : nil;
        }
    }
    
    searchLawyer.strTitle = @"附近律师";
    searchLawyer.hidesBottomBarWhenPushed = YES;
    [self pushViewController:searchLawyer];
}

#pragma mark - Lawfirm Data Soucre

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
    return @[@"不限",
             @"福田区法院",
             @"南山区法院",
             @"罗湖区法院",
             @"盐田区法院",
             @"宝安区法院",
             @"龙岗区法院",
             @"深圳市中级法院",
             @"市民中心",
             @"招商银行大厦",
             @"赛格广场",
             @"地王大厦",
             @"国贸大厦",
             @"海岸城"];
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
        
        // latitude是第二个,longitude是第一个,所以取值的时候先 index:1 再 index:0
        return CLLocationCoordinate2DMake([[loaction objectAtIndex:1] doubleValue], [[loaction objectAtIndex:0] doubleValue]);
    }
    return CLLocationCoordinate2DMake(22.526431, 114.060687);
}

#pragma mark - push method

// 指定坐标
- (void)pushSearchDeatalVCWithSearchKey:(NSString *)key
{
    SearchDeatalViewController *vc = [[SearchDeatalViewController alloc] init];
    vc.strTitle = @"律所";
    vc.isShowMapView = YES;
    vc.searchKey = key;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:vc];
}

/**
 *  进入律师搜索页面
 *
 *  @param key           搜索的key
 *  @param hidden        是否在下个视图隐藏搜索的key
 *  @param hasCoordinate 是否已经有指定坐标
 */
- (void)pushSearchLawyerVCWithSearchKey:(NSString *)key
{
    SearchLawyerViewController *vc = [[SearchLawyerViewController alloc] init];
    vc.strTitle = @"律师";
    vc.isShowMapView = YES;
    vc.isHiddenSearchKey = NO;
    vc.searchKey = key;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushViewController:vc];
}

#pragma mark - UITextFieldDelegate

- (void)clickNavCancelBtn:(UIButton *)sender
{
    [_serachTextField setText:nil];
    [_serachTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (![textField hasText])
    {
        [self showHUDInfoByString:@"请输入搜索名称"];
    }
    else
    {
        // 搜索律师
        if (_searchType == TheSearchType_lawyer)
        {
            [self pushSearchLawyerVCWithSearchKey:textField.text];
        }
        // 搜索律所
        else if (_searchType == TheSearchType_lawfirm)
        {
            [self pushSearchDeatalVCWithSearchKey:textField.text];
        }
    }
    
    
    return YES;
}

@end
