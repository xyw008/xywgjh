//
//  ConsultInfoVC.m
//  Find lawyer
//
//  Created by leo on 14-10-15.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ConsultInfoVC.h"
#import "ImageAddView.h"
#import "CTAssetsPickerController.h"
#import "EXPhotoViewer.h"
#import "PopupController.h"

#define kEdgeSpace 10

@interface ConsultInfoVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
{
    UIScrollView        *_bgSrcollView;//背景滚动视图
    
    ImageAddView        *_imageAddView;//添加图片的背景视图
    
    UILabel             *_selectTypeLB;//选择咨询类型显示Label
    UIView              *_selectTypeBgView;//选择咨询类型的背景视图
    
    UITextView          *_textView;//咨询问题输入视图
    UIButton            *_sendInfoBtn;//发送消息按钮
    
    NSArray             *_typeArray;//可选择咨询类型数组
}
@end

@implementation ConsultInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _typeArray = @[@"刑事辩护",@"婚姻家庭",@"民商经济",@"劳动人事",@"行政诉讼",@"知识产权",@"交通事故",@"房产建筑",@"银行保险",@"金融证券",@"并购上市",@"涉外国际",@"法律顾问"];
    
    [self initImageAddView];
    [self initSelectBgView];
    [self initTextViewAndSendBtn];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initImageAddView
{
    _imageAddView = [[ImageAddView alloc] initWithFrame:CGRectMake(kEdgeSpace, 10, self.view.width - kEdgeSpace*2, 100)];
    _imageAddView.backgroundColor = [UIColor redColor];
    _imageAddView.delegate = self;
    _imageAddView.edgeDistance = 20;
    [self.view addSubview:_imageAddView];
}

- (void)initSelectBgView
{
    _selectTypeBgView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeSpace, [self getSelectBgViewOriginY], _imageAddView.width, 38)];
    _selectTypeBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectTypeBgView];
    
    _selectTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 95, 22)];
    _selectTypeLB.textAlignment = NSTextAlignmentRight;
    _selectTypeLB.text = @"咨询类型:";
    _selectTypeLB.font = SP15Font;
    [_selectTypeBgView addSubview:_selectTypeLB];

    UIColor *borderColor = ATColorRGBMake(159, 159, 159);
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectTypeLB.frame) + 4, _selectTypeLB.frameOriginY + 3, 66, 18)];
    selectBtn.layer.borderColor = borderColor.CGColor;
    selectBtn.layer.borderWidth = 0.5;
    [selectBtn setTitleColor:borderColor forState:UIControlStateNormal];
    [selectBtn setTitle:@"请选择" forState:UIControlStateNormal];
    selectBtn.titleLabel.font = SP15Font;
    [selectBtn addTarget:self action:@selector(selectTypeBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_selectTypeBgView addSubview:selectBtn];
}

- (void)initTextViewAndSendBtn
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(_selectTypeBgView.frameOriginX, [self getTextViewOriginY], _selectTypeBgView.width, 100)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_textView];
    
    CGFloat btnWidht = 100;
    _sendInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - btnWidht/2, [self getSendBtnOriginY], btnWidht, 40)];
    [_sendInfoBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [_sendInfoBtn addTarget:self action:@selector(sendInfoBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendInfoBtn];
    
}

#pragma mark - get Bg View origin.y
- (CGFloat)getSelectBgViewOriginY
{
    return CGRectGetMaxY(_imageAddView.frame) + 1;
}

- (CGFloat)getTextViewOriginY
{
    return CGRectGetMaxY(_selectTypeBgView.frame) + 6;
}

- (CGFloat)getSendBtnOriginY
{
    return CGRectGetMaxY(_textView.frame) + 6;
}

#pragma mark - btn touch event
- (void)selectTypeBtnTouch:(UIButton*)btn
{
    
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_selectTypeBgView.frame) + 6, 180, 200)];
    pick.delegate = self;
    pick.dataSource = self;
    pick.backgroundColor = [UIColor whiteColor];
    
    PopupController *pop = [[PopupController alloc] initWithContentView:pick];
    pop.delegate = self;
    pop.animated = NO;
    pop.behavior = PopupBehavior_MessageBox;
    [pop showInView:self.view animatedType:PopAnimatedType_Fade];
    
}

- (void)sendInfoBtnTouch:(UIButton*)btn
{
    
}

#pragma mark - ImageAddView delegate
- (void)ImageAddViewMyHeightHasChange:(ImageAddView *)addView
{
    _selectTypeBgView.frameOriginY = [self getSelectBgViewOriginY];
    _textView.frameOriginY = [self getTextViewOriginY];
    _sendInfoBtn.frameOriginY = [self getSendBtnOriginY];
}

- (void)ImageAddViewWantAddImage:(ImageAddView*)addView
{
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 6;
        picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.delegate = self;
        picker.showsCancelButton = YES;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (0 == buttonIndex)
    {
        UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
        ipc.sourceType= UIImagePickerControllerSourceTypeCamera;
        ipc.delegate=self;
        ipc.allowsEditing=NO;
        [self presentViewController:ipc animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WEAKSELF
    [picker dismissViewControllerAnimated:NO completion:^() {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        STRONGSELF
        [strongSelf->_imageAddView addImage:image];
        [strongSelf.view layoutSubviews];
    }];
}


#pragma mark - CTAssetsPickerController delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    
}

#pragma mark - UIPickerView datasouce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_typeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_typeArray objectAtIndex:row];
}

#pragma mark - UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectTypeLB.text = [_typeArray objectAtIndex:row];
}

@end
