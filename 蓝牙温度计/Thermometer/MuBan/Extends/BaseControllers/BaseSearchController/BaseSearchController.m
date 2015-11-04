//
//  BaseSearchController.m
//  o2o
//
//  Created by leo on 14-8-12.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseSearchController.h"
#import "ProductListVC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "NITextField.h"
#import "AppPropertiesInitialize.h"

#define kKeyboradAddHeight 20

@interface BaseSearchController ()<UITextFieldDelegate,NetRequestDelegate, UISearchBarDelegate>
{
    NoSearchResultView              *_noSearchResultView;//没有搜索结果提示视图
    
    UISearchBar                     *_searchBar;
}

- (void)deleteSearchText;

@end

@implementation BaseSearchController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [AppPropertiesInitialize setKeyboardManagerEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [AppPropertiesInitialize setKeyboardManagerEnable:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    [self initSearchView];
    */
    [self configureNavSearchBar];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboradChangeFrame:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboradWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
     */
    
}

#pragma mark - init method

// search bar
- (void)configureNavSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 50 * 2, self.navigationController.navigationBar.boundsHeight - 8 * 2)];
    titleView.backgroundColor = [UIColor whiteColor];
    [titleView setRadius:2];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    UIImage *fieldImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(_searchBar.boundsWidth, _searchBar.boundsHeight)];
    // fieldImage = [UIImage createRoundedRectImage:fieldImage roundedRectSize:CGSizeMake(2, 2)];
    
    [_searchBar setSearchFieldBackgroundImage:fieldImage forState:UIControlStateNormal];
    [_searchBar setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([_searchBar respondsToSelector:@selector(setBarTintColor:)])
    {
        _searchBar.barTintColor = Common_ThemeColor;
    }
    [_searchBar setDelegate:self];
    [_searchBar setPlaceholder:LocalizedStr(HomePage_SeachPlaceholder)];
    
    // 修改searchBar的属性
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    
    // Get the instance of the UITextField of the search bar
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    // Change search bar text color
    searchField.textColor = Common_BlackColor;
    // Change the search bar placeholder text color
    [searchField setValue:Common_GrayColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [titleView addSubview:_searchBar];
    self.navigationItem.titleView = titleView;
    
    // cancel button
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                            barButtonTitle:LocalizedStr(All_Cancel)
                                    action:@selector(clickNavCancelBtn:)];
    
    // search History View
    [self initSearchHistoryView];
}

- (void)hiddenOrShowSearchBar:(BOOL)hidden
{
    [self.view bringSubviewToFront:_historyAndSuggestView];
    
    WEAKSELF
    [_historyAndSuggestView animationFadeWithExecuteBlock:^{
        STRONGSELF
        strongSelf->_historyAndSuggestView.hidden = hidden;
    }];
}

//搜索框视图
- (void)initSearchView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,IPHONE_WIDTH*225/320, 30)];
    
    _searchTF = [[NITextField alloc] initWithFrame:titleView.bounds];
    _searchTF.delegate = self;
  
    /**
     @ 修改描述     修改_searchTF属性
     @ 修改人       龚俊慧
     @ 修改时间     2015-11-21
     */
    /***************************修改开始***************************/
    _searchTF.placeholder = LocalizedStr(HomePage_SeachPlaceholder);
    _searchTF.placeholderFont = SP15Font;
    _searchTF.placeholderTextColor = Common_GrayColor;
    _searchTF.textColor = Common_BlackColor;
    _searchTF.font = SP15Font;
    /*
    _searchTF.layer.borderWidth = 1;
    _searchTF.layer.borderColor = Common_GrayColor.CGColor;
     */
    [_searchTF setRadius:2];
    /***************************修改结束***************************/
    
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.backgroundColor = [UIColor whiteColor];
    
    //左边搜索logo
    UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.frame = CGRectMake(0, 0, 26, 15);
    [logoBtn setImage:[UIImage imageNamed:@"leimu-icon-sousuo"] forState:UIControlStateNormal];
    logoBtn.enabled = NO;
    _searchTF.leftView = logoBtn;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    
    //右边删除搜索文字按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(0, 0, 26, 15);
    [deleteBtn setImage:[UIImage imageNamed:@"leimu-icon-shanchu"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"leimu-icon-shanchu-dianji"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteSearchTextBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    _searchTF.rightView = deleteBtn;
    _searchTF.rightViewMode = UITextFieldViewModeAlways;
    
    [titleView addSubview:_searchTF];
    self.navigationItem.titleView = titleView;
    
    _cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelSearchBtn.frame = CGRectMake(0, 0, 40, 40);
    _cancelSearchBtn.titleLabel.font = SP14Font;
    [_cancelSearchBtn setTitle:LocalizedStr(All_Cancel) forState:UIControlStateNormal];
    _cancelSearchBtn.hidden = YES;
    [_cancelSearchBtn addTarget:self action:@selector(cancelSearchBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cancelSearchBtn];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
    
    /* 
     *  暂时不需要二维码扫描了
     *
    UIButton *qrCode = [UIButton buttonWithType:UIButtonTypeCustom];
    qrCode.frame = CGRectMake(0, 22, 40, 40);
    [qrCode setImage:[UIImage imageNamed:@"leimu-icon-saoma"] forState:UIControlStateNormal];
    [qrCode setImage:[UIImage imageNamed:@"leimu-icon-saoma-dianji"] forState:UIControlStateHighlighted];
    UIBarButtonItem *qrCodeButton = [[UIBarButtonItem alloc] initWithCustomView:qrCode];
    
    self.navigationItem.rightBarButtonItem = qrCodeButton;  
     
     */
}

//初始化搜索历史视图
- (void)initSearchHistoryView
{
//    _historyAndSuggestView = [[SearchHistoryAndSuggestView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, self.viewFrameHeight - KeyboardHeight + kKeyboradAddHeight)];
    
    /*
    CGFloat viewHeight = self.view.boundsHeight - KeyboardHeight;
     */
    CGFloat viewHeight = self.view.boundsHeight;
    
    if (!self.navigationController.tabBarController.tabBar.hidden)
    {
        viewHeight += self.navigationController.tabBarController.tabBar.height;
    }
    
    _historyAndSuggestView = [[SearchHistoryAndSuggestView alloc] initWithFrame:CGRectMake(0, 0, self.view.frameWidth, viewHeight)];
    _historyAndSuggestView.delegate = self;
    _historyAndSuggestView.hidden = YES;
    [_historyAndSuggestView keepAutoresizingInFull];
    
    [self.view addSubview:_historyAndSuggestView];
    [self.view bringSubviewToFront:_historyAndSuggestView];
}

- (void)initNoSearchResultView
{
    _noSearchResultView = [[NoSearchResultView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_noSearchResultView];
}

- (void)hideNoSearchResultView:(BOOL)hide
{
    if (hide)
        [_noSearchResultView removeFromSuperview];
    else
        [self initNoSearchResultView];
}

#pragma mark - btn touch event
- (void)qrCodeBtnTouch:(UIButton*)btn
{
    
}

//删除搜索
- (void)deleteSearchTextBtnTouch:(UIButton*)btn
{
    if ([self.view.subviews containsObject:_noSearchResultView])
    {
        [self.view sendSubviewToBack:_noSearchResultView];
        [_noSearchResultView removeFromSuperview];
    }
    _lastSearchStr = _searchTF.text;
    _searchTF.text = @"";
    [_searchTF endEditing:YES];
    [self deleteSearchText];
}

//取消搜索
- (void)cancelSearchBtnTouch:(UIButton*)btn
{
    [_searchTF endEditing:YES];
    _cancelSearchBtn.hidden = YES;
}

#pragma mark - SearchHistoryAndSuggestView delegate
- (void)SearchHistoryAndSuggestView:(SearchHistoryAndSuggestView*)historyView didSelectHistoryOrSuggestString:(NSString*)string
{
    /*
    [_searchTF endEditing:YES];
     */
    [_searchBar resignFirstResponder];
    [self hiddenOrShowSearchBar:YES];
    [self saveHistoryWithSearchText:string];
    
    //如果是再商品详情视图控制器 直接发起新的商品列表请求
    if ([self judgeClassIsProductOneCategoryListVC])
    {
        _searchTF.text = string;
//        [self searchRequest:string];
        [self getNetworkData];
    }
    //其他视图 推到商品列表视图控制器
    else
    {
        ProductListVC *productList = [[ProductListVC alloc] initWithSearchStr:string];
        productList.hidesBottomBarWhenPushed = YES;
        [self pushViewController:productList];
    }
}

- (void)theScrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

- (void)saveHistoryWithSearchText:(NSString *)text
{
    NSMutableArray *history = [NSMutableArray arrayWithArray:[UserInfoModel getUserDefaultSearchHistoryArray]];
    
    if ([history containsObject:text])
    {
        [history removeObject:text];
        [history insertObject:text atIndex:0];
    }
    else
    {
        [history insertObject:text atIndex:0];
    }
    [UserInfoModel setUserDefaultSearchHistoryArray:history];
}

- (BOOL)judgeClassIsProductOneCategoryListVC
{
    return [self isKindOfClass:[ProductListVC class]];
}

#pragma mark - Request
- (void)suggestRequest:(NSString*)newString
{
    NSDictionary *prarmeterDic = @{@"keyword":newString};
    
    NSURL *url = [UrlManager getRequestUrlByMethodName:[[self class] getRequestURLStr:NetProductRequestType_GetSearchQuerySuggest] andArgsDic:prarmeterDic];
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:prarmeterDic
                                  requestMethodType:RequestMethodType_GET
                                         requestTag:NetProductRequestType_GetSearchQuerySuggest
                                           delegate:self
                                           userInfo:nil];
    
//    [self sendRequest:[[self class] getRequestURLStr:NetProductRequestType_GetSearchQuerySuggest] parameterDic:prarmeterDic requestMethodType:RequestMethodType_GET requestTag:NetProductRequestType_GetSearchQuerySuggest];
}

- (void)searchRequest:(NSString*)searchString
{
    NSDictionary *prarmeterDic = @{@"keyword": searchString};
    NSURL *url = [UrlManager getRequestUrlByMethodName:[[self class] getRequestURLStr:NetProductRequestType_PostSearchQueryProducts]];
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:prarmeterDic
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:NetProductRequestType_PostSearchQueryProducts
                                           delegate:self
                                           userInfo:nil];
    
//    [self sendRequest:[[self class] getRequestURLStr:NetProductRequestType_PostSearchQueryProducts] parameterDic:prarmeterDic requestMethodType:RequestMethodType_POST requestTag:NetProductRequestType_PostSearchQueryProducts];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [super netRequest:request successWithInfoObj:infoObj];
    switch (request.tag)
    {
        case NetProductRequestType_PostSearchQueryProducts:
        {
            NSArray *array = [[infoObj objectForKey:@"data"] objectForKey:@"products"];
            if ([array isAbsoluteValid])
            {
                //是否隐藏搜索结果
                [self hideNoSearchResultView:[array count] > 0 ? YES:NO];
            }
        }
            break;
        case NetProductRequestType_GetSearchQuerySuggest:
            _historyAndSuggestView.suggestResultArray = [infoObj objectForKey:@"suggests"];
            break;
        default:
            break;
    }
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [super netRequest:request failedWithError:error];
    switch (request.tag)
    {
        case NetProductRequestType_PostSearchQueryProducts:
            [self hideNoSearchResultView:NO];
            break;
        case NetProductRequestType_GetSearchQuerySuggest:
            
            break;
        default:
            break;
    }
}


#pragma mark - Custom method

//移除 _historyAndSuggestView 视图
- (void)removeHistoryAndSuggestView
{
    _historyAndSuggestView.hidden = YES;
    [_historyAndSuggestView removeFromSuperview];
    _historyAndSuggestView = nil;
    [self.view endEditing:YES];
}

#pragma mark - UITextFiledDelegate

/*
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_historyAndSuggestView == nil)
    {
        _cancelSearchBtn.hidden = NO;
        [self initSearchHistoryView];
    }
    if (textField.text.length > 0)
    {
        [self suggestRequest:textField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *nowText = textField.text;
    NSString *newText = nowText;
    //删除
    if (range.length == 1)
        newText = [nowText substringWithRange:NSMakeRange(0,nowText.length - 1)];
    //继续输入
    else
        newText = [nowText stringByAppendingString:string];
    
    [self suggestRequest:newText];
    return YES;
}

//keyboard return touch
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    //保存搜索记录
    if (textField.text.length > 0)
    {
        BOOL haveChange = NO;
        NSMutableArray *historyArray = [[NSMutableArray alloc] init];
        [historyArray addObjectsFromArray:[UserInfoModel getUserDefaultSearchHistoryArray]];
        if ([historyArray isAbsoluteValid])
        {
            //不包含当前搜索字符串
            if (![historyArray containsObject:textField.text])
            {
                [historyArray insertObject:textField.text atIndex:0];
                haveChange = YES;
            }
        }
        else
        {
            [historyArray addObject:textField.text];
            haveChange = YES;
        }
        //搜索记录有改变，保存搜索记录
        if (haveChange) {
            [UserInfoModel setUserDefaultSearchHistoryArray:historyArray];
        }
        

        [textField endEditing:YES];
        //如果是再商品详情视图控制器 直接发起新的商品列表请求
        if ([self isKindOfClass:[ProductListVC class]])
        {
            [self removeHistoryAndSuggestView];
//            NSDictionary *prarmeterDic = @{@"keyword": textField.text};
//            //由字视图 ProductOneCategoryListVC 类去处理结果
//            [self sendRequest:[[self class] getRequestURLStr:NetProductRequestType_PostSearchQueryProducts] parameterDic:prarmeterDic requestMethodType:RequestMethodType_POST requestTag:NetProductRequestType_PostSearchQueryProducts];
            [self getNetworkData];
        }
        //其他视图 推到商品列表视图控制器
        else
        {
            [self.navigationController pushViewController:[[ProductListVC alloc] initWithSearchStr:textField.text] animated:YES];
        }
    }
    //搜索为空
    else
    {
        [self showHUDInfoByString:@"请输入要搜索的内容"];
    }
    return YES;
}
*/

/*
#pragma mark - Keyborad notification
- (void)keyboradWillHide:(NSNotification*)notification
{
    [self removeHistoryAndSuggestView];
}

- (void)keyboradChangeFrame:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSValue *keyboardBoundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];
    
//    CGFloat viewHeight = self.viewFrameHeight - keyboardEndRect.size.height + kKeyboradAddHeight;
    CGFloat viewHeight = self.viewFrameHeight - keyboardEndRect.size.height;
    
    if (!self.navigationController.tabBarController.tabBar.hidden)
        viewHeight += self.navigationController.tabBarController.tabBar.height;
    
    [UIView beginAnimations:@"changeSearchHistoryViewFrame" context:nil];
    [UIView setAnimationDuration:duration];
    if (_historyAndSuggestView) {
        [_historyAndSuggestView changeViewAndTableViewHeight:viewHeight];
    }
    [UIView commitAnimations];
}
*/

#pragma mark - subView rewrite method

//删除搜索文字
- (void)deleteSearchText
{
    //子类重写
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // [searchBar setShowsCancelButton:YES animated:YES];
    [self hiddenOrShowSearchBar:NO];
    
    if (searchBar.text.length > 0)
    {
        [self suggestRequest:searchBar.text];
        [_historyAndSuggestView setTabShowStyle:1];
    }
    else
    {
        [_historyAndSuggestView setTabShowStyle:0];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length > 0)
    {
        [self suggestRequest:searchText];
        [_historyAndSuggestView setTabShowStyle:1];
    }
    else
    {
        [_historyAndSuggestView setTabShowStyle:0];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    /*
    [searchBar setShowsCancelButton:NO animated:YES];
    [self hiddenOrShowSearchBar:YES];
     */
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:nil];
    [searchBar resignFirstResponder];
    [self hiddenOrShowSearchBar:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0)
    {
        // 保存历史记录
        [self saveHistoryWithSearchText:searchBar.text];
        
        // 隐藏及跳转
        [self hiddenOrShowSearchBar:YES];
        [searchBar setShowsCancelButton:NO animated:YES];
        [searchBar resignFirstResponder];

        ProductListVC *productList = [[ProductListVC alloc] initWithSearchStr:searchBar.text];
        productList.hidesBottomBarWhenPushed = YES;
        [self pushViewController:productList];
    }
    else
    {
        [self showHUDInfoByString:@"请输入要搜索的内容"];
    }
    
}

- (void)clickNavCancelBtn:(UIButton *)sender
{
    [_searchBar setText:nil];
    [_searchBar resignFirstResponder];
    [self hiddenOrShowSearchBar:YES];
}

@end
