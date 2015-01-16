//
//  SearchVC.m
//  Find lawyer
//
//  Created by 龚 俊慧 on 15/1/14.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "SearchVC.h"
#import "SearchItemCollectionCell.h"

static NSString * const cellIdentifier_collecitonViewCell = @"cellIdentifier_collecitonViewCell";
static NSString * const cellIdentifier_collecitonViewHeader = @"cellIdentifier_collecitonViewHeader";
static NSString * const cellIdentifier_collecitonViewFooter = @"cellIdentifier_collecitonViewFooter";

@interface SearchVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@end

@implementation SearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

- (void)initialization
{
    // collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(IPHONE_WIDTH / 3, 30);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView setAllowsMultipleSelection:YES];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SearchItemCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifier_collecitonViewCell];
    
//    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ChannelEditHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier_collecitonViewHeader];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier_collecitonViewCell forIndexPath:indexPath];
    
//    NewsTypeEntity *entity = _selectedNewsTypeArray[indexPath.item];
//    cell.titleLabel.text = entity.newsTypeNameStr;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier_collecitonViewHeader forIndexPath:indexPath];
        return view;
    }
    
    return nil;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(collectionView.boundsWidth, 50);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(collectionView.boundsWidth, 33);
//}

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

@end
