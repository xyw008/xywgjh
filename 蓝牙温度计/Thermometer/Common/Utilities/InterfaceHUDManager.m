//
//  InterfaceHUDManager.m
//  o2o
//
//  Created by swift on 14-8-25.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "InterfaceHUDManager.h"
#import "AppDelegate.h"
#import "PopupController.h"

@interface InterfaceHUDManager () <GJHAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray  *_allCountiesDataArray;  // 从文件读中取的全世界各个国家的省市区数据
    
    NSMutableArray  *_curCountiesArray;
    NSMutableArray  *_curCountiesIdArray;
    
    NSMutableArray  *_curProvincesArray;
    NSMutableArray  *_curProvincesIdArray;
    
    NSMutableArray  *_curCitiesArray;
    NSMutableArray  *_curCitiesIdArray;
    
    NSMutableArray  *_curAreasArray;
    NSMutableArray  *_curAreasIdArray;
    
    PopupController *_popupController;
    UIView          *_pickerView;
    PickerShowType  _pickerShowType;
}

// alert
@property (nonatomic, copy) GJHAlertBlock cancelBlock;
@property (nonatomic, copy) GJHAlertBlock otherBlock;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *otherButtonTitle;

// picker
@property (nonatomic, copy) PickerOperationBlock pickerCancelBlock;
@property (nonatomic, copy) PickerOperationBlock pickerConfirmBlock;

@end

@implementation InterfaceHUDManager

DEF_SINGLETON(InterfaceHUDManager);

- (id)init
{
    self = [super init];
    if (self)
    {
        // 初始化数据
        [self getProvinceAndCityData];
        [self getPickerCurrentShowDatasWithCountryIndex:0
                                         provincesIndex:0
                                              cityIndex:0];
    }
    return self;
}

- (void)showAutoHideAlertWithMessage:(NSString *)message
{
    [self showAlertWithTitle:nil message:message buttonTitle:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    [self showAlertWithTitle:title message:message alertShowType:AlertShowType_Informative cancelTitle:buttonTitle cancelBlock:nil otherTitle:nil otherBlock:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message alertShowType:(AlertShowType)type cancelTitle:(NSString *)cancelTitle cancelBlock:(GJHAlertBlock)cancelBlock otherTitle:(NSString *)otherTitle otherBlock:(GJHAlertBlock)otherBlock
{
    GJHAlertView *alert = [[GJHAlertView alloc] initWithTitle:title message:message isInputContentView:NO delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alert.defaultButtonTitleColor = Common_BlackColor;
    alert.defaultButtonFont = SP16Font;
    alert.titleLabel.font = SP16Font;
    alert.titleLabel.textColor = Common_BlackColor;
    alert.messageLabel.font = SP16Font;
    if (AlertShowType_Informative == type)
    {
        alert.messageLabel.textColor = Common_BlackColor;
    }
    else
    {
        alert.messageLabel.textColor = Common_ThemeColor;
    }
    
    if (!cancelBlock && !otherBlock)
    {
        alert.delegate = nil;
        
        alert.shouldDismissOnTouchOutside = YES;
        alert.autoDismissAfterDelay = HUDAutoHideTypeShowTime;
    }
    
    self.cancelBlock = cancelBlock;
    self.otherBlock = otherBlock;
    self.cancelButtonTitle = cancelTitle;
    self.otherButtonTitle = otherTitle;
    
    [alert show];
}

#pragma mark - GJHAlertViewDelegate methods

- (void)alertView:(GJHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:self.cancelButtonTitle])
    {
        if (self.cancelBlock) self.cancelBlock(alertView, buttonIndex);
    }
    else if ([buttonTitle isEqualToString:self.otherButtonTitle])
    {
        if (self.otherBlock) self.otherBlock(alertView, buttonIndex);
    }
}

#pragma mark - /////////////////////////////////////////////////////////////////////////

// 获取全世界各个国家所有省市区数据
- (void)getProvinceAndCityData
{
    if (!_allCountiesDataArray)
    {
        NSString *addressFileStr = GetApplicationPathFileName(@"Address", @"json");
        NSData *addressFileData = [NSData dataWithContentsOfFile:addressFileStr];
        
        NSDictionary *addressDic = [NSJSONSerialization JSONObjectWithData:addressFileData options:NSJSONReadingMutableContainers error:NULL];
        
        if ([addressDic isAbsoluteValid])
        {
            _allCountiesDataArray = [[addressDic safeObjectForKey:@"data"] safeObjectForKey:@"countrieAddressInfo"];   // 全世界国家的地址
        }
//        DLog(@"%@",addressDic);
    }
}

- (void)getPickerCurrentShowDatasWithCountryIndex:(NSInteger)countryIndex provincesIndex:(NSInteger)provincesIndex cityIndex:(NSInteger)cityIndex
{
    // 国家(只要加载一次数据)
    if (!_curCountiesArray)
    {
        _curCountiesArray = [NSMutableArray array];
        _curCountiesIdArray = [NSMutableArray array];
        for (NSDictionary *countryDic in _allCountiesDataArray)
        {
            NSDictionary *country = [countryDic safeObjectForKey:@"country"];
            
            [_curCountiesArray addObject:[country objectForKey:@"name"]];
            [_curCountiesIdArray addObject:[country safeObjectForKey:@"id"]];
        }
    }
    
    // 省
    _curProvincesArray = [NSMutableArray array];
    _curProvincesIdArray = [NSMutableArray array];
    NSDictionary *countryDic = [self getCountryDicWtihIndex:countryIndex];
    NSArray *provinceArray = [countryDic safeObjectForKey:@"province"];
    for (NSDictionary *province in provinceArray)
    {
        [_curProvincesArray addObject:[province objectForKey:@"name"]];
        [_curProvincesIdArray addObject:[province safeObjectForKey:@"id"]];
    }
    
    // 市
    _curCitiesArray = [NSMutableArray array];
    _curCitiesIdArray = [NSMutableArray array];
    NSDictionary *provinceDic = provincesIndex < provinceArray.count ? provinceArray[provincesIndex] : nil;
    NSArray *cityArray = [provinceDic objectForKey:@"city"];
    for (NSDictionary *city in cityArray)
    {
        [_curCitiesArray addObject:[city objectForKey:@"name"]];
        [_curCitiesIdArray addObject:[city safeObjectForKey:@"id"]];
    }
    
    // 区
    _curAreasArray = [NSMutableArray array];
    _curAreasIdArray = [NSMutableArray array];
    NSDictionary *cityDic = cityIndex < cityArray.count ? cityArray[cityIndex] : nil;
    NSArray *areaArray = [cityDic objectForKey:@"area"];
    for (NSDictionary *area in areaArray)
    {
        [_curAreasArray addObject:[area objectForKey:@"name"]];
        [_curAreasIdArray addObject:[area safeObjectForKey:@"id"]];
    }
}

- (void)getCurCountryIndex:(NSInteger *)countryIndex provinceIndex:(NSInteger *)provinceIndex cityIndex:(NSInteger *)cityIndex areaIndex:(NSInteger *)areaIndex inAddressStr:(NSString *)addressStr
{
    *countryIndex = NSNotFound;
    *provinceIndex = NSNotFound;
    *cityIndex = NSNotFound;
    *areaIndex = NSNotFound;
    
    // 国家的index
    for (NSString *countryStr in _curCountiesArray)
    {
        if ([addressStr containsString:countryStr])
        {
            *countryIndex = [_curCountiesArray indexOfObject:countryStr];
            break;
        }
    }
    if (*countryIndex == NSNotFound) return;
    [self getPickerCurrentShowDatasWithCountryIndex:*countryIndex
                                     provincesIndex:0
                                          cityIndex:0];
    
    // 省的index
    for (NSString *provinceStr in _curProvincesArray)
    {
        if ([addressStr containsString:provinceStr])
        {
            *provinceIndex = [_curProvincesArray indexOfObject:provinceStr];
            break;
        }
    }
    if (*provinceIndex == NSNotFound) return;
    [self getPickerCurrentShowDatasWithCountryIndex:*countryIndex
                                     provincesIndex:*provinceIndex
                                          cityIndex:0];
    
    // 市的index
    for (NSString *cityStr in _curCitiesArray)
    {
        if ([addressStr containsString:cityStr])
        {
            *cityIndex = [_curCitiesArray indexOfObject:cityStr];
            break;
        }
    }
    if (*cityIndex == NSNotFound) return;
    [self getPickerCurrentShowDatasWithCountryIndex:*countryIndex
                                     provincesIndex:*provinceIndex
                                          cityIndex:*cityIndex];
    
    // 区的index
    for (NSString *areaStr in _curAreasArray)
    {
        if ([addressStr containsString:areaStr])
        {
            *areaIndex = [_curAreasArray indexOfObject:areaStr];
            break;
        }
    }
}

- (NSArray *)getCurIdsArrayInAddressStr:(NSString *)addressStr
{
    NSInteger countryIndex;
    NSInteger provinceIndex;
    NSInteger cityIndex;
    NSInteger areaIndex;
    
    [self getCurCountryIndex:&countryIndex
               provinceIndex:&provinceIndex
                   cityIndex:&cityIndex
                   areaIndex:&areaIndex
                inAddressStr:addressStr];
    
    NSNumber *countryId = countryIndex < _curCountiesIdArray.count ? _curCountiesIdArray[countryIndex] : @(NSNotFound);
    NSNumber *provinceId = provinceIndex < _curProvincesIdArray.count ? _curProvincesIdArray[provinceIndex] : @(NSNotFound);
    NSNumber *cityId = cityIndex < _curCitiesIdArray.count ? _curCitiesIdArray[cityIndex] : @(NSNotFound);
    NSNumber *areaId = areaIndex < _curAreasIdArray.count ? _curAreasIdArray[areaIndex] : @(NSNotFound);
    
    return @[countryId, provinceId, cityId, areaId];
}

- (NSDictionary *)getCountryDicWtihIndex:(NSInteger)index
{
    NSDictionary *countryDic = index < _allCountiesDataArray.count ? _allCountiesDataArray[index] : nil;
    
    return [countryDic safeObjectForKey:@"country"];
}

- (void)showPickerWithTitle:(NSString *)title PickerShowType:(PickerShowType)type pickerCancelBlock:(PickerOperationBlock)pickerCancelBlock pickerConfirmBlock:(PickerOperationBlock)pickerConfirmBlock
{
    [self showPickerWithTitle:title PickerShowType:type defaultSelectedStr:nil pickerCancelBlock:pickerCancelBlock pickerConfirmBlock:pickerConfirmBlock];
}

- (void)showPickerWithTitle:(NSString *)title PickerShowType:(PickerShowType)type defaultSelectedStr:(NSString *)selectedStr pickerCancelBlock:(PickerOperationBlock)pickerCancelBlock pickerConfirmBlock:(PickerOperationBlock)pickerConfirmBlock
{
    self.pickerCancelBlock = pickerCancelBlock;
    self.pickerConfirmBlock = pickerConfirmBlock;
    _pickerShowType = type;
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:NULL];
    // 定义一个关闭的barBtn
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithTitle:Cancel style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelOrConfirmBtn:)];
    
    // 定义一个确定的barBtn
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithTitle:Confirm style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelOrConfirmBtn:)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = title;
    navItem.leftBarButtonItems = @[negativeSeperator, closeBarBtn];
    navItem.rightBarButtonItems = @[negativeSeperator, confirmBarBtn];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 44)];
    navBar.items = [NSArray arrayWithObject:navItem];
    
    // picker
    if (PickerShowType_Date == type)
    {
        _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, IPHONE_WIDTH, 70)];
        [(UIDatePicker *)_pickerView setDatePickerMode:UIDatePickerModeDate];
        
        // 默认被选中的位置
        if ([selectedStr isAbsoluteValid])
        {
            [(UIDatePicker *)_pickerView setDate:[NSString dateFromString:selectedStr withFormatter:@"yyyy-MM-dd"]];
        }
    }
    else
    {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, IPHONE_WIDTH, 70)];
        [(UIPickerView *)_pickerView setShowsSelectionIndicator:YES];
        [(UIPickerView *)_pickerView setDataSource:self];
        [(UIPickerView *)_pickerView setDelegate:self];
        
        [self getPickerCurrentShowDatasWithCountryIndex:0
                                         provincesIndex:0
                                              cityIndex:0];
        
        // 默认被选中的位置
        if ([selectedStr isAbsoluteValid])
        {
            NSInteger countryIndex;
            NSInteger provinceIndex;
            NSInteger cityIndex;
            NSInteger areaIndex;
            
            [self getCurCountryIndex:&countryIndex
                       provinceIndex:&provinceIndex
                           cityIndex:&cityIndex
                           areaIndex:&areaIndex
                        inAddressStr:selectedStr];
            
            countryIndex = (countryIndex == NSNotFound ? 0 : countryIndex);
            provinceIndex = (provinceIndex == NSNotFound ? 0 : provinceIndex);
            cityIndex = (cityIndex == NSNotFound ? 0 : cityIndex);
            areaIndex = (areaIndex == NSNotFound ? 0 : areaIndex);
            
            [(UIPickerView *)_pickerView selectRow:countryIndex inComponent:0 animated:YES];
            [(UIPickerView *)_pickerView selectRow:provinceIndex inComponent:1 animated:YES];
            [(UIPickerView *)_pickerView selectRow:cityIndex inComponent:2 animated:YES];
            [(UIPickerView *)_pickerView selectRow:areaIndex inComponent:3 animated:YES];
        }
    }
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight; // 这里设置了就可以自定义高度了,一般默认是无法修改其216像素的高度的
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    // 呈现
    UIView *popupContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, navBar.boundsHeight + _pickerView.boundsHeight)];
    [popupContentView addSubview:navBar];
    [popupContentView addSubview:_pickerView];
    
    _popupController = [[PopupController alloc] initWithContentView:popupContentView];
    _popupController.behavior = PopupBehavior_MessageBox;
    [_popupController showInView:[UIApplication sharedApplication].keyWindow animatedType:PopAnimatedType_CurlDown];
}

- (void)clickCancelOrConfirmBtn:(UIBarButtonItem *)sender
{
    [_popupController hide];
    
    // 点击事件处理
    if ([sender.title isEqualToString:Cancel])
    {
        if (_pickerCancelBlock) _pickerCancelBlock(nil, nil);
    }
    else
    {
        NSArray *idsArray = nil;
        
        // 组装被选择的字符串
        NSString *pickedContentStr = nil;
        
        if (PickerShowType_Date == _pickerShowType)
        {
            pickedContentStr = [NSDate stringFromDate:((UIDatePicker *)_pickerView).date withFormatter:@"yyyy-MM-dd"];
        }
        else
        {
            UIPickerView *picker = (UIPickerView *)_pickerView;
            
            NSInteger countryIndex = [picker selectedRowInComponent:0];
            NSInteger provinceIndex = [picker selectedRowInComponent:1];
            NSInteger cityIndex = [picker selectedRowInComponent:2];
            NSInteger areaIndex = [picker selectedRowInComponent:3];
            
            NSString *countryStr = [_curCountiesArray isAbsoluteValid] ? _curCountiesArray[countryIndex] : @"";
            NSNumber *countryId = countryIndex < _curCountiesIdArray.count ? _curCountiesIdArray[countryIndex] : @(NSNotFound);
            
            NSString *provinceStr = [_curProvincesArray isAbsoluteValid] ? _curProvincesArray[provinceIndex] : @"";
            NSNumber *provinceId = provinceIndex < _curProvincesIdArray.count ? _curProvincesIdArray[provinceIndex] : @(NSNotFound);
            
            NSString *cityStr = [_curCitiesArray isAbsoluteValid] ? _curCitiesArray[cityIndex] : @"";
            NSNumber *cityId = cityIndex < _curCitiesIdArray.count ? _curCitiesIdArray[cityIndex] : @(NSNotFound);
            
            NSString *areaStr = [_curAreasArray isAbsoluteValid] ? _curAreasArray[areaIndex] : @"";
            NSNumber *areaId = areaIndex < _curAreasIdArray.count ? _curAreasIdArray[areaIndex] : @(NSNotFound);
            
            pickedContentStr = [NSString stringWithFormat:@"%@%@%@%@",countryStr, provinceStr, cityStr, areaStr];
            idsArray = @[countryId, provinceId, cityId, areaId];
        }
        
        if (_pickerConfirmBlock) _pickerConfirmBlock(pickedContentStr, idsArray);
    }
    
    [self clearPickerProperties];
}

- (void)clearPickerProperties
{
    self.pickerCancelBlock = nil;
    self.pickerConfirmBlock = nil;
    _popupController = nil;
    _pickerView = nil;
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            return _curCountiesArray.count;
        }
            break;
        case 1:
        {
            return _curProvincesArray.count;
        }
            break;
        case 2:
        {
            return _curCitiesArray.count;
        }
            break;
        case 3:
        {
            return _curAreasArray.count;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = InsertLabel(nil, CGRectMake(0, 0, _pickerView.boundsWidth / 3, 20), NSTextAlignmentCenter, nil, SP16Font, [UIColor blackColor], NO);
    
    switch (component)
    {
        case 0:
        {
            titleLabel.text = _curCountiesArray[row];
            return titleLabel;
        }
            break;
        case 1:
        {
            titleLabel.text = _curProvincesArray[row];
            return titleLabel;
        }
            break;
        case 2:
        {
            titleLabel.text = _curCitiesArray[row];
            return titleLabel;
        }
            break;
        case 3:
        {
            titleLabel.text = _curAreasArray[row];
            return titleLabel;
        }
            break;
            
        default:
        {
            return nil;
        }
            break;
    }
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            return _curProvincesArray[row];
        }
            break;
        case 1:
        {
            return _curCitiesArray[row];
        }
            break;
        case 2:
        {
            return _curAreasArray[row];
        }
            break;
            
        default:
        {
            return nil;
        }
            break;
    }
}
*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component)
    {
        // 更新数据
        [self getPickerCurrentShowDatasWithCountryIndex:row
                                         provincesIndex:0
                                              cityIndex:0];
        
        // 刷新数据
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView reloadComponent:3];
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView selectRow:0 inComponent:3 animated:YES];
    }
    else if (1 == component)
    {
        // 更新数据
        NSInteger countryIndex = [pickerView selectedRowInComponent:0];
        [self getPickerCurrentShowDatasWithCountryIndex:countryIndex
                                         provincesIndex:row
                                              cityIndex:0];
        
        // 刷新数据
        [pickerView reloadComponent:2];
        [pickerView reloadComponent:3];
        
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView selectRow:0 inComponent:3 animated:YES];
    }
    else if (2 == component)
    {
        // 更新数据
        NSInteger countryIndex = [pickerView selectedRowInComponent:0];
        NSInteger provinceIndex = [pickerView selectedRowInComponent:1];
        [self getPickerCurrentShowDatasWithCountryIndex:countryIndex
                                         provincesIndex:provinceIndex
                                              cityIndex:row];
        
        // 刷新数据
        [pickerView reloadComponent:3];

        [pickerView selectRow:0 inComponent:3 animated:YES];
    }
}

@end
