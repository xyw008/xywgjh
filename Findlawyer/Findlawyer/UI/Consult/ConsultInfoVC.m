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

#define kEdgeSpace 10

@interface ConsultInfoVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CTAssetsPickerControllerDelegate>
{
    UIScrollView        *_bgSrcollView;//背景滚动视图
    
    ImageAddView        *_imageAddView;//添加图片的背景视图
    
    UILabel             *_selectTypeLB;//选择咨询类型显示Label
    UIView              *_selectTypeBgView;//选择咨询类型的背景视图
}
@end

@implementation ConsultInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImageAddView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initImageAddView
{
    _imageAddView = [[ImageAddView alloc] initWithFrame:CGRectMake(kEdgeSpace, 10, self.view.width - kEdgeSpace*2, 100)];
    _imageAddView.delegate = self;
    [self.view addSubview:_imageAddView];
}

- (void)initSelectBgView
{
    _selectTypeBgView = [[UIView alloc] initWithFrame:CGRectMake(kEdgeSpace, CGRectGetMaxY(_imageAddView.frame) + 1, _imageAddView.width, 43)];
    _selectTypeBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectTypeBgView];
    
    _selectTypeLB = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 95, 22)];
    _selectTypeLB.textAlignment = NSTextAlignmentRight;
    _selectTypeLB.text = @"咨询类型";
    _selectTypeLB.font = SP15Font;
}


#pragma mark - ImageAddView delegate
- (void)ImageAddViewWantAddImage:(ImageAddView*)addView
{
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 6;
        picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.delegate = self;
        picker.showsCancelButton = YES;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (1 == buttonIndex)
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


@end
