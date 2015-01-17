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

static NSString * const cellIdentifier_collecitonViewCell   = @"cellIdentifier_collecitonViewCell";
static NSString * const cellIdentifier_collecitonViewHeader = @"cellIdentifier_collecitonViewHeader";
static NSString * const cellIdentifier_collecitonViewFooter = @"cellIdentifier_collecitonViewFooter";

@interface SearchVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray          *_searchShowDataArray;
    
    UICollectionView *_collectionView;
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
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchItemCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifier_collecitonViewCell];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchCollectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier_collecitonViewHeader];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchCollectionFooterView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cellIdentifier_collecitonViewFooter];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
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
    if (1 == section)
    {
        return [SearchCollectionFooterView getViewSize];
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = [collectionView indexPathsForSelectedItems];
    
    if ([indexPaths isAbsoluteValid])
    {
        for (NSIndexPath *path in indexPaths)
        {
            if (path.section == indexPath.section)
            {
                [collectionView deselectItemAtIndexPath:path animated:YES];
            }
        }
    }
    
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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
    return @[@"福田区法院",
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

@end
