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
#import "YGPopupController.h"
#import "PickerAlertTypeManager.h"
#import "NetRequestManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UploadImageBC.h"
#import "HUDManager.h"

#define kEdgeSpace 10
#define kCancelBtnStr @"   取消"
#define kConfirmBtnStr @"确定   "
#define kDefaultBtnText @"请选择"

#define kGetAskIdRequestTag 1000

@interface ConsultInfoVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate>
{
    UIScrollView        *_bgSrcollView;//背景滚动视图
    
    ImageAddView        *_imageAddView;//添加图片的背景视图
    
    UILabel             *_selectTypeLB;//选择咨询类型显示Label
    UIView              *_selectTypeBgView;//选择咨询类型的背景视图
    UIButton            *_selectBtn;//选择咨询类型btn
    
    UILabel             *_textViewPlaceholderLB;
    UITextView          *_textView;//咨询问题输入视图
    UIButton            *_sendInfoBtn;//发送消息按钮
    
    NSArray             *_typeArray;//可选择咨询类型数组
    
    YGPopupController   *_popupController;//弹出视图
    NSString            *_wantSelectStr;//将要选择的咨询领域
    
    UploadImageBC       *_uploadImageBC;//上传图片
    BOOL                _allPhotoUploadSuccess;//所有图片上传成功
    
    NSString            *_askId;//咨询ID (通过网络请求获取)
    NSMutableArray      *_uploadImgArray;//需要上传图片的数组
    
    BOOL                _willUploadImgButNoAskId;//要传图片但是没有 askId
    BOOL                _willSaveAskInfo;//将要上传图片详细 （如果图片还在上传就要等图片上传完成再发送保存请求）
    
//    NSInteger           *_wantUploadIndex;//下个将要上传图片所在数组index
    
}
@end

@implementation ConsultInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _typeArray = kSpecialtyDomainArray;
    _willSaveAskInfo = NO;
    _allPhotoUploadSuccess = YES;
    
    [self initImageAddViewAndBgScrollView];
    [self initSelectBgView];
    [self initTextViewAndSendBtn];
    [self setNetworkRequestStatusBlocks];
    [self getNetworkData];
    
    self.title = [NSString stringWithFormat:@"咨询 - %@",_lawyerItem.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initImageAddViewAndBgScrollView
{
    _bgSrcollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bgSrcollView.backgroundColor = HEXCOLOR(0xF9F9F9);
    [_bgSrcollView keepAutoresizingInFull];
    [self.view addSubview:_bgSrcollView];
    
    _imageAddView = [[ImageAddView alloc] initWithFrame:CGRectMake(kEdgeSpace, 10, self.view.width - kEdgeSpace*2, 100)];
    _imageAddView.backgroundColor = [UIColor whiteColor];
    _imageAddView.delegate = self;
    _imageAddView.edgeDistance = 20;
    [_bgSrcollView addSubview:_imageAddView];
}

- (void)initSelectBgView
{
    _selectTypeBgView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeSpace, [self getSelectBgViewOriginY], _imageAddView.width, 38)];
    _selectTypeBgView.backgroundColor = [UIColor whiteColor];
    [_bgSrcollView addSubview:_selectTypeBgView];
    
    _selectTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 95, 22)];
    _selectTypeLB.textAlignment = NSTextAlignmentRight;
    _selectTypeLB.text = @"咨询类型:";
    _selectTypeLB.font = SP15Font;
    [_selectTypeBgView addSubview:_selectTypeLB];

    UIColor *borderColor = ATColorRGBMake(159, 159, 159);
    _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectTypeLB.frame) + 4, _selectTypeLB.frameOriginY, 80, 23)];
    _selectBtn.layer.borderColor = borderColor.CGColor;
    _selectBtn.layer.borderWidth = 0.5;
    [_selectBtn setTitleColor:borderColor forState:UIControlStateNormal];
    [_selectBtn setTitle:kDefaultBtnText forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = SP15Font;
    [_selectBtn addTarget:self action:@selector(selectTypeBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_selectTypeBgView addSubview:_selectBtn];
}

- (void)initTextViewAndSendBtn
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(_selectTypeBgView.frameOriginX, [self getTextViewOriginY], _selectTypeBgView.width, 120)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    [_bgSrcollView addSubview:_textView];
    
    _textViewPlaceholderLB = [[UILabel alloc] initWithFrame:CGRectMake((_textView.width - 170)/2, [self getTextViewPlaceholderLBOriginY], 170, 20)];
    _textViewPlaceholderLB.text = @"简要描述案情(500字内)";
    _textViewPlaceholderLB.textColor = ATColorRGBMake(159, 159, 159);
    _textViewPlaceholderLB.backgroundColor = [UIColor clearColor];
    _textViewPlaceholderLB.userInteractionEnabled = NO;
    _textViewPlaceholderLB.font = SP15Font;
    [_bgSrcollView addSubview:_textViewPlaceholderLB];
    
    CGFloat btnWidht = 220;
    _sendInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2 - btnWidht/2, [self getSendBtnOriginY], btnWidht, 32)];
    [_sendInfoBtn setTitle:@"发送咨询" forState:UIControlStateNormal];
    [_sendInfoBtn addTarget:self action:@selector(sendInfoBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    _sendInfoBtn.layer.cornerRadius = 2;
    _sendInfoBtn.backgroundColor = ATColorRGBMake(20, 139, 230);
    
    [_bgSrcollView addSubview:_sendInfoBtn];
    [self setBgSrcollViewContentSize];
}

#pragma mark - get Bg View origin.y or contentSize method
- (CGFloat)getSelectBgViewOriginY
{
    return CGRectGetMaxY(_imageAddView.frame) + 1;
}

- (CGFloat)getTextViewOriginY
{
    return CGRectGetMaxY(_selectTypeBgView.frame) + 25;
}

- (CGFloat)getTextViewPlaceholderLBOriginY
{
    return _textView.frameOriginY;
}

- (CGFloat)getSendBtnOriginY
{
    return CGRectGetMaxY(_textView.frame) + 12;
}


- (void)setBgSrcollViewContentSize
{
    CGFloat height = CGRectGetMaxY(_sendInfoBtn.frame) + 20;
    _bgSrcollView.contentSize = CGSizeMake(0, height);
    _bgSrcollView.scrollEnabled = height > _bgSrcollView.height ? YES:NO;
}


#pragma mark - btn touch event
- (void)selectTypeBtnTouch:(UIButton*)btn
{
    // 定义一个关闭的barBtn
    UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithTitle:kCancelBtnStr style:UIBarButtonItemStyleBordered target:self action:@selector(clickCancelOrConfirmBtn:)];
    
    // 定义一个确定的barBtn
    UIBarButtonItem *confirmBarBtn = [[UIBarButtonItem alloc] initWithTitle:kConfirmBtnStr style:UIBarButtonItemStylePlain target:self action:@selector(clickCancelOrConfirmBtn:)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title =@"咨询类型";
    navItem.leftBarButtonItem = closeBarBtn;
    navItem.rightBarButtonItem = confirmBarBtn;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 44)];
    navBar.items = [NSArray arrayWithObject:navItem];
    navBar.backgroundColor = [UIColor whiteColor];
    
    UIView *actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.height - 194, IPHONE_WIDTH, 194)];
    actionSheetView.backgroundColor = [UIColor whiteColor];
    
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, IPHONE_WIDTH, 150)];
    pick.delegate = self;
    pick.dataSource = self;
    [pick setShowsSelectionIndicator:YES];
    pick.backgroundColor = [UIColor whiteColor];
    pick.autoresizingMask = UIViewAutoresizingFlexibleHeight; // 这里设置了就可以自定义高度了,一般默认是无法修改其216像素的高度的
    
    [actionSheetView addSubview:pick];
    [actionSheetView addSubview:navBar];
    
    _popupController = [[YGPopupController alloc] initWithContentView:actionSheetView];
    _popupController.delegate = self;
    _popupController.behavior = YGPopupBehavior_AutoHidden;
    [_popupController showInView:[UIApplication sharedApplication].keyWindow animatedType:YGPopAnimatedType_CurlDown];
}

- (void)sendInfoBtnTouch:(UIButton*)btn
{
    [self saveAskInfoReuqest];
}

- (void)clickCancelOrConfirmBtn:(UIBarButtonItem *)sender
{
    // 点击事件处理
    if ([sender.title isEqualToString:kCancelBtnStr])
    {
        [_popupController hideAnimatied:YES];
    }
    else
    {
//        _selectTypeLB.text = _wantSelectStr;
        CGSize size = [_wantSelectStr stringSizeWithFont:_selectBtn.titleLabel.font];
        [_selectBtn setTitle:_wantSelectStr forState:UIControlStateNormal];
        _selectBtn.width = size.width + 20;
        [_popupController hideAnimatied:YES];
    }
}


#pragma mark - request method

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        
        STRONGSELF
        if (successInfoObj && [successInfoObj isKindOfClass:[NSDictionary class]])
        {
            
            switch (request.tag)
            {
                case NetConsultInfoRequestType_GetAskId:
                {
                    NSArray *askArray = [successInfoObj objectForKey:@"Ask"];
                    if ([askArray isAbsoluteValid])
                    {
                        NSDictionary *askDic = [askArray objectAtIndex:0];
                        if ([askDic isAbsoluteValid])
                        {
                            strongSelf->_askId = [askDic objectForKey:@"AskId"];
                            //如果要上传图片时候发现没有askId，而且发起的请求的情况
                            if (strongSelf->_willUploadImgButNoAskId)
                            {
                                [strongSelf uploadImgArray:strongSelf->_uploadImgArray];
                                strongSelf->_willUploadImgButNoAskId = NO;
                                strongSelf->_uploadImgArray = nil;
                            }
                        }
                    }
                }
                    break;
                case NetConsultInfoRequestType_PostSaveAskInfo:
                {
                    [HUDManager showAutoHideHUDWithToShowStr:@"发送成功" HUDMode:MBProgressHUDModeText];
                    [strongSelf performSelector:@selector(backViewController) withObject:nil afterDelay:HUDAutoHideTypeShowTime];
                }
                default:
                    break;
            }
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        DLog(@"SD");
    }];
}

- (void)getNetworkData
{
    if (_lawyerItem.lawerid)
    {
        NSDictionary *parm = @{@"lawyerId":_lawyerItem.lawerid};
        [self sendRequest:[BaseNetworkViewController getRequestURLStr:NetConsultInfoRequestType_GetAskId] parameterDic:parm requestHeaders:nil requestMethodType:RequestMethodType_GET requestTag:NetConsultInfoRequestType_GetAskId];
    }
}

- (void)saveAskInfoReuqest
{
    if (_allPhotoUploadSuccess)
    {
        if (_askId)
        {
            if ([_selectBtn.titleLabel.text isEqualToString:kDefaultBtnText])
            {
                [self showHUDInfoByString:@"请选择咨询类型"];
                return;
            }
            
            if (_textView.text.length > 0)
            {
                _willSaveAskInfo = NO;
                
                //擅长领域ID，是所在数组index + 1
                NSString *askTypeId = [NSString stringWithFormat:@"%d",([_typeArray indexOfObject:_selectBtn.titleLabel.text] + 1)];
                NSNumber *typeId = [[NSNumber alloc] initWithInteger:[askTypeId integerValue]];
                
                DLog(@"succeed str = %@",[_uploadImageBC getSucceedReultStr]);
                NSDictionary *parm = @{@"askId":_askId,@"askTypeId":typeId,@"content":_textView.text,@"PhotoSaves":[_uploadImageBC getSucceedReultStr]};
                
//                [self sendRequest:[BaseNetworkViewController getRequestURLStr:NetConsultInfoRequestType_PostSaveAskInfo] parameterDic:parm requestHeaders:nil requestMethodType:RequestMethodType_POST requestTag:NetConsultInfoRequestType_PostSaveAskInfo];
            }
            else
            {
                [self showHUDInfoByString:@"请填写咨询内容"];
            }
        }
        else
        {
            [self showHUDInfoByString:@"上传失败"];
        }
    }
    else
    {
        [HUDManager showHUDWithToShowStr:@"正在上传图片..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
        _willSaveAskInfo = YES;
    }
}

#pragma mark - YGPopupController delegate

- (void)YGPopupControllerDidHidden:(YGPopupController *)aController
{
    _popupController.delegate = nil;
    _popupController = nil;
}

#pragma mark - ImageAddView delegate
- (void)ImageAddViewMyHeightHasChange:(ImageAddView *)addView
{
    _selectTypeBgView.frameOriginY = [self getSelectBgViewOriginY];
    _textView.frameOriginY = [self getTextViewOriginY];
    _textViewPlaceholderLB.frameOriginY = [self getTextViewPlaceholderLBOriginY];
    _sendInfoBtn.frameOriginY = [self getSendBtnOriginY];
    
    [self setBgSrcollViewContentSize];
}

- (void)ImageAddViewWantAddImage:(ImageAddView*)addView
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle = UIActionSheetStyleAutomatic;
    [menu showInView:self.view];
}

- (void)ImageAddView:(ImageAddView *)addView deleteImg:(UIImage*)img
{
    [_uploadImageBC deleteImg:img];
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
        [strongSelf uploadImgArray:@[image]];
        [strongSelf.view layoutSubviews];
    }];
}


#pragma mark - CTAssetsPickerController delegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *imgArray = [[NSMutableArray alloc] initWithCapacity:assets.count];
    for (ALAsset *asset in assets) {
        [imgArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
    }
    [_imageAddView addImageArray:imgArray];
    [self uploadImgArray:imgArray];
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
    _wantSelectStr = [_typeArray objectAtIndex:row];
    return [_typeArray objectAtIndex:row];
}

#pragma mark - UIPickerView delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    _wantSelectStr = [_typeArray objectAtIndex:row];
}

#pragma mark - UITextView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    _textViewPlaceholderLB.hidden = textView.text.length == 0 ? NO:YES;
}

#pragma mark - upload img

- (void)uploadImgArray:(NSArray*)array
{
    if (![array isAbsoluteValid])
        return;
    
    if (_askId != nil)
    {
        _allPhotoUploadSuccess = NO;
        if (_uploadImageBC == nil)
        {
            WEAKSELF
            _uploadImageBC = [[UploadImageBC alloc] initWithAskId:_askId UploadImgArray:array uploadStateBlock:^(BOOL success) {
                STRONGSELF
                //暂时都算上传成功，这里应该记录上失败图片，在图标显示地方提示点击重新上传才合逻辑
                strongSelf->_allPhotoUploadSuccess = YES;
                if (success)
                {
                    //如果还要发起保存请求
                    if (_willSaveAskInfo)
                    {
                        [strongSelf saveAskInfoReuqest];
                    }
                }
                else
                {
                    if (_willSaveAskInfo)
                    {
                        [strongSelf showHUDInfoByString:@"上传失败"];
                    }
                }
            }];
        }
        else
        {
            [_uploadImageBC addUploadImgArray:array];
        }
    }
    else
    {
        if (_uploadImgArray == nil)
            _uploadImgArray = [[NSMutableArray alloc] initWithArray:array];
        else
            [_uploadImgArray addObjectsFromArray:array];
        
        _willUploadImgButNoAskId = YES;
        [self getNetworkData];
    }
}


@end
