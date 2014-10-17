//
//  PickAlertTypeManager.m
//  Find lawyer
//
//  Created by leo on 14-10-17.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "PickerAlertTypeManager.h"

@interface PickerAlertTypeManager ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray             *_dataSourceArray;
    UIActionSheet       *_actionSheetView;
    UIPickerView        *_pickerView;
    NSString            *_selectStr;
}


@property (nonatomic, copy) PickerBlock pickerCancelBlock;
@property (nonatomic, copy) PickerBlock pickerConfirmBlock;

@end

@implementation PickerAlertTypeManager

DEF_SINGLETON(PickerAlertTypeManager);


- (void)showPickerWithTitle:(NSString *)title dataSourceArray:(NSArray *)array pickerCancelBlock:(PickerBlock)pickerCancelBlock pickerConfirmBlock:(PickerBlock)pickerConfirmBlock
{
    _dataSourceArray = array;
    _pickerCancelBlock = pickerCancelBlock;
    _pickerConfirmBlock = pickerConfirmBlock;
    
    // 定义一个关闭的barBtn
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithTitle:Cancel style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelOrConfirmBtn:)];
    
    // 定义一个确定的barBtn
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithTitle:Confirm style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelOrConfirmBtn:)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = title;
    navItem.leftBarButtonItem = closeBarBtn;
    navItem.rightBarButtonItem = confirmBarBtn;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 44)];
    navBar.items = [NSArray arrayWithObject:navItem];
    
    // 这里的高度还有待完善,最好是用自定义的view推出展示不要用actionSheet(这个用换行不太好控制高度)
    _actionSheetView = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, IPHONE_WIDTH, 70)];
    
    [_pickerView setShowsSelectionIndicator:YES];
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];
    
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight; // 这里设置了就可以自定义高度了,一般默认是无法修改其216像素的高度的
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    [_actionSheetView addSubview:_pickerView];
    [_actionSheetView addSubview:navBar];
    [_actionSheetView showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)clickCancelOrConfirmBtn:(UIBarButtonItem *)sender
{
    [_actionSheetView dismissWithClickedButtonIndex:0 animated:YES];
    // 点击事件处理
    if ([sender.title isEqualToString:Cancel])
    {
        if (_pickerCancelBlock) _pickerCancelBlock(nil);
    }
    else
    {
        if (_pickerConfirmBlock) _pickerCancelBlock(_selectStr);
    }
    [self clearPickerProperties];
}

- (void)clearPickerProperties
{
    _pickerCancelBlock = nil;
    _pickerConfirmBlock = nil;
    _actionSheetView = nil;
    _pickerView = nil;
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataSourceArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_dataSourceArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectStr = [_dataSourceArray objectAtIndex:row];
}

@end
