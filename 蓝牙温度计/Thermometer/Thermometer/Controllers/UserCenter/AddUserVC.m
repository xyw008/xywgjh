//
//  AddUserVC.m
//  Thermometer
//
//  Created by leo on 15/11/22.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AddUserVC.h"
#import "InterfaceHUDManager.h"
#import "SlideActionSheet.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "CommonEntity.h"
#import "DateTools.h"
#import "AccountStautsManager.h"

#import "SystemConvert.h"
#import "BabyToy.h"

#import "AppPropertiesInitialize.h"


#define kMargin 12
#define kFont SP15Font

#define kRoleBtnStartTag 1000

@interface AddUserVC ()
{
    UIImageView     *_headIV;//头像
    UITextField     *_nameTF;
    UILabel         *_sexLB;//性别
    UILabel         *_ageLB;
    
    UIButton        *_lastSelectRoleBtn;
    
    NSString        *_sexString;
    NSString        *_ageString;
    NSString        *_birthdayStr;
    
    UIImage         *_headImage;//选择的头像图片
}
@end

@implementation AddUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItemTitle:_userItem ? LocalizedStr(member_managed) : LocalizedStr(add_member)];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                                 normalImg:[UIImage imageNamed:@"navigationbar_icon_chose"]
                            highlightedImg:[UIImage imageNamed:@"navigationbar_icon_chose"]
                                    action:@selector(submitAddUser)];
    
    [self initHeadAndNameView];
    [self initSexAndAgeView];
    [self initRoleView];
    
    if (_userItem)
    {
        _nameTF.text = _userItem.userName;
        _sexLB.text = _userItem.gender == 0 ? LocalizedStr(male) : LocalizedStr(female);
        _ageLB.text = [NSString stringWithInt:_userItem.age];
        _sexString = _sexLB.text;
        _ageString = _ageLB.text;
        if (_userItem.image) {
            _headIV.image = _userItem.image;
        }
        
        UIButton *btn = [self.view viewWithTag:_userItem.role - 1 + kRoleBtnStartTag];
        if (btn && [btn isKindOfClass:[UIButton class]]) {
            btn.selected = YES;
            _lastSelectRoleBtn = btn;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // [AppPropertiesInitialize setBackgroundColorToStatusBar:Common_ThemeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHeadAndNameView
{
    CGFloat headHeight = DynamicWidthValue640(190);
    _headIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_userhead"]];
    ViewRadius(_headIV, headHeight/2);
    [_headIV addTarget:self action:@selector(selectHeadImage)];
    [self.view addSubview:_headIV];
    
    UIView *oneLineView = [self createLineView:NO];
    
    UIImageView *nameLogoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adduser_icon_name"]];
    [self.view addSubview:nameLogoIV];
    
    _nameTF = [[UITextField alloc] init];
    _nameTF.font = kFont;
    _nameTF.placeholder = LocalizedStr(enter_nickname);
    [self.view addSubview:_nameTF];
    
    [_headIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(22);
        make.width.equalTo(headHeight);
        make.height.equalTo(headHeight);
    }];
    
    [oneLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headIV.mas_bottom).offset(50);
    }];
    
    [nameLogoIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneLineView.mas_bottom).offset(13);
        make.left.equalTo(oneLineView.mas_left).offset(15);
        make.height.equalTo(DynamicWidthValue640(64));
        make.width.equalTo(DynamicWidthValue640(64));
    }];
    
    [_nameTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLogoIV.mas_right).offset(12);
        make.right.equalTo(oneLineView.mas_right).offset(-12);
        make.height.equalTo(35);
        make.centerY.equalTo(nameLogoIV.mas_centerY);
    }];
}

- (void)initSexAndAgeView
{
    UIView *twoLineView = [self createLineView:NO];
    
    UIImageView *sexLogoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adduser_icon_sex"]];
    [self.view addSubview:sexLogoIV];
    
    UIImageView *sexArrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown"]];
    [self.view addSubview:sexArrowIV];
    
    _sexLB = [[UILabel alloc] init];
    _sexLB.backgroundColor = [UIColor clearColor];
    _sexLB.textColor = Common_BlackColor;
    _sexLB.font = _nameTF.font;
    _sexLB.text = LocalizedStr(gender);
    [_sexLB addTarget:self action:@selector(selectSex:)];
    [self.view addSubview:_sexLB];
    
    UIImageView *ageLogoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adduser_icon_birthday"]];
    [self.view addSubview:ageLogoIV];
    
    UIImageView *ageArrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown"]];
    [self.view addSubview:ageArrowIV];
    
    _ageLB = [[UILabel alloc] init];
    _ageLB.backgroundColor = [UIColor clearColor];
    _ageLB.textColor = Common_BlackColor;
    _ageLB.font = _nameTF.font;
    _ageLB.text = LocalizedStr(age);
    [_ageLB addTarget:self action:@selector(selectAge:)];
    [self.view addSubview:_ageLB];
    
    UIView *leftLineView = [self createLineView:YES];
    UIView *rightLineView = [self createLineView:YES];
    
    
    [twoLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTF.mas_bottom).offset(12);
    }];
    
    [sexLogoIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoLineView.mas_bottom).offset(13);
        make.left.equalTo(twoLineView.mas_left).offset(15);
        make.height.equalTo(DynamicWidthValue640(64));
        make.width.equalTo(DynamicWidthValue640(64));
    }];
    
    [_sexLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sexLogoIV.mas_centerY);
        make.left.equalTo(sexLogoIV.mas_right).offset(15);
        make.right.equalTo(leftLineView.mas_right).offset(0);
        make.height.equalTo(42);
    }];
    
    [sexArrowIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftLineView.mas_right).offset(-5);
        make.bottom.equalTo(sexLogoIV.mas_bottom);
        make.width.equalTo(11);
        make.height.equalTo(11);
    }];
    
    [leftLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexLogoIV.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(kMargin);
    }];
    
    [rightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-kMargin);
        make.top.equalTo(leftLineView.mas_top);
    }];
    
    [ageLogoIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sexLogoIV.mas_centerY);
        make.left.equalTo(rightLineView.mas_left).offset(15);
        make.width.equalTo(sexLogoIV.mas_width);
        make.height.equalTo(sexLogoIV.mas_height);
    }];
    
    [_ageLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ageLogoIV.mas_centerY);
        make.left.equalTo(ageLogoIV.mas_right).offset(15);
        make.height.equalTo(_sexLB.mas_height);
        make.width.equalTo(_sexLB.mas_width);
    }];
    
    [ageArrowIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sexArrowIV.mas_top);
        make.right.equalTo(rightLineView.mas_right).offset(-5);
        make.width.equalTo(sexArrowIV.mas_width);
        make.height.equalTo(sexArrowIV.mas_height);
    }];
}

- (void)initRoleView
{
    UILabel *roleTitleLB = [[UILabel alloc] init];
    roleTitleLB.font = _nameTF.font;
    roleTitleLB.textColor = Common_BlackColor;
    roleTitleLB.text = LocalizedStr(family_role);
    [self.view addSubview:roleTitleLB];
    
    
    NSArray *imageArray = @[@"adduser_icon_baby_n",
                            @"adduser_icon_mother_n",
                            @"adduser_icon_father_n",
                            @"adduser_icon_grandm_n",
                            @"adduser_icon_grandf_n"];
    
    NSArray *selectImageArray = @[@"adduser_icon_baby_f",
                                  @"adduser_icon_mother_f",
                                  @"adduser_icon_father_f",
                                  @"adduser_icon_grandm_f",
                                  @"adduser_icon_grandf_f"];
    
    NSInteger num = imageArray.count;
    CGFloat margin = 22;
    CGFloat space = 11;
    CGFloat btnWidth = (IPHONE_WIDTH - 22 * 2 - space * (num - 1))/num;
    
    [roleTitleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sexLB.mas_bottom).offset(35);
        make.left.equalTo(self.view.mas_left).offset(margin);
        make.right.equalTo(self.view.mas_right).offset(-margin);
        make.height.equalTo(18);
    }];
    
    UIButton *lastBtn;
    for (NSInteger i=0; i<num; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kRoleBtnStartTag + i;
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImageArray[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(roleBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (0 == i)
        {
            if (!_userItem)
            {
                _lastSelectRoleBtn = btn;
                btn.selected = YES;
            }
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(roleTitleLB.mas_bottom).offset(15);
                make.left.equalTo(roleTitleLB.mas_left);
                make.height.equalTo(btnWidth);
                make.width.equalTo(btnWidth);
            }];
        }
        else
        {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn.mas_top);
                make.left.equalTo(lastBtn.mas_right).offset(space);
                make.height.equalTo(lastBtn.mas_height);
                make.width.equalTo(lastBtn.mas_width);
            }];
        }
        
        lastBtn = btn;
    }
}


- (UIView*)createLineView:(BOOL)isHalf
{
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = CellSeparatorColor;
    [self.view addSubview:lineView];
    
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(ThinLineWidth);
        if (isHalf)
        {
            make.width.equalTo((IPHONE_WIDTH - kMargin * 3)/2);
        }
        else
        {
            make.left.equalTo(self.view.mas_left).offset(kMargin);
            make.right.equalTo(self.view.mas_right).offset(-kMargin);
        }
    }];
    return lineView;
}

- (void)setUserItem:(UserItem *)userItem
{
    _userItem = userItem;
    
    _birthdayStr = [NSDate stringFromDate:[[NSDate date] dateBySubtractingYears:userItem.age] withFormatter:DataFormatter_Date];
}

#pragma mark - request 

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (successInfoObj && [successInfoObj isKindOfClass:[NSDictionary class]])
        {
            switch (request.tag)
            {
                case NetUserRequestType_AddUser:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddUserSuccessNotificationKey object:nil userInfo:@{kNewUserName : strongSelf->_nameTF.text}];
                    [weakSelf backViewController];
                }
                    break;
                case NetUserRequestType_ChangeUserInfo:
                {
                    strongSelf->_userItem.userName = strongSelf->_nameTF.text;
                    strongSelf->_userItem.gender = [strongSelf->_sexString isEqualToString:LocalizedStr(male)] ? 0 : 1;
                    strongSelf->_userItem.age = [strongSelf->_ageString integerValue];
                    strongSelf->_userItem.role = strongSelf->_lastSelectRoleBtn.tag - kRoleBtnStartTag + 1;
                    if (strongSelf->_headImage) {
                        strongSelf->_userItem.image = strongSelf->_headImage;
                    }
                    
                    [AccountStautsManager sharedInstance].nowUserItem = strongSelf->_userItem;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kAddUserSuccessNotificationKey object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeUserSuccessNotificationKey object:nil];
                    
                    [weakSelf backViewController];
                }
                    break;
                default:
                    break;
            }
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        [weakSelf showHUDInfoByString:error.localizedDescription];
    }];
}

- (void)getNetworkData
{
    NSInteger gender = [_sexString isEqualToString:LocalizedStr(male)] ? 0 : 1;
    NSString *imageString = @"";
    if (_headImage)
    {
        //压缩图片到宽度最大
        CGFloat maxWidth = 200;
        UIImage *resizeImg = _headImage;
        if (resizeImg.size.width > maxWidth)
        {
            CGSize originalSize = resizeImg.size;
            resizeImg = [resizeImg resize:CGSizeMake(maxWidth, originalSize.height*maxWidth/originalSize.width)];
        }
        
        NSData *data = UIImageJPEGRepresentation(resizeImg, .3);
        NSString *str = [NSString stringWithFormat:@"%@", data];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        //imageString = [SystemConvert binaryToHex:str];
        
        imageString = str;
        DLog(@"imagestrin = %@",imageString);
        
//        NSData* newData= [str dataUsingEncoding:NSUTF16StringEncoding];
//        _headIV.image = [UIImage imageWithData:data];
        
        // NSString *hex = [SystemConvert binaryToHex:@"101"];
        
        // NSLog(@"%@", hex);
    }
    NSDictionary *memberDic = @{@"name":_nameTF.text,
                                @"gender":@(gender),
                                @"age":@([_ageString integerValue]),
                                @"role":@(_lastSelectRoleBtn.tag - kRoleBtnStartTag + 1),
                                @"image":imageString};
    
    
    NetRequestType type = NetUserRequestType_AddUser;
    if (_userItem)
    {
        NSString *nowImageStr = [imageString isAbsoluteValid] ? imageString : _userItem.imageStr;
        
        type = NetUserRequestType_ChangeUserInfo;
        memberDic = @{@"name":_userItem.userName,
                      @"gender":@(gender),
                      @"age":@([_ageString integerValue]),
                      @"role":@(_lastSelectRoleBtn.tag - kRoleBtnStartTag + 1),
                      @"image":nowImageStr,
                      @"newName":_nameTF.text};
    }
    NSArray *memberList = @[memberDic];
    
    [self sendRequest:[[self class] getRequestURLStr:type]
         parameterDic:@{@"phone":[UserInfoModel getUserDefaultLoginName],@"memberList":memberList}
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:type];
    
}

#pragma mark - touch
- (void)submitAddUser
{
    if (![_nameTF.text isAbsoluteValid])
    {
        [self showHUDInfoByString:LocalizedStr(enter_nickname)];
        return;
    }
    
    if (![_sexString isAbsoluteValid]) {
        [self showHUDInfoByString:LocalizedStr(please_choose_gender)];
        return;
    }
    
    if (![_ageString isAbsoluteValid]) {
        [self showHUDInfoByString:LocalizedStr(please_enter_age)];
        return;
    }
    
    if (!_lastSelectRoleBtn) {
        [self showHUDInfoByString:LocalizedStr(please_choose_member_type)];
        return;
    }
    
    [self showHUDInfoByString:_userItem ? LocalizedStr(modify_success) : LocalizedStr(add_success)];
    [self getNetworkData];
}

- (NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

- (void)selectHeadImage
{
    // [AppPropertiesInitialize setBackgroundColorToStatusBar:[UIColor clearColor]];

    WEAKSELF
    [self pickSinglePhotoFromCameraOrAlbumByIsCropped:YES cancelHandle:nil finishPickingHandle:^(NSArray *pickedImageArray) {
        
        STRONGSELF
        if ([pickedImageArray isAbsoluteValid])
        {
            UIImage *pickerImage = pickedImageArray[0];
            
            //[headerView setUserHeaderImage:pickerImage];
            strongSelf->_headIV.image = pickerImage;
            strongSelf->_headImage = pickerImage;
        }
    }];
}

//选择性别
- (void)selectSex:(UITapGestureRecognizer*)tap
{
    WEAKSELF
    [[SlideActionSheet sharedInstance] showActionSheetTitleString:LocalizedStr(gender) stringArray:@[LocalizedStr(male),LocalizedStr(female)] selectHnadle:^(NSInteger selectIndex, NSString *selectStr) {
        STRONGSELF
        strongSelf->_sexString = selectStr;
        strongSelf->_sexLB.text = selectStr;
    }];
}

//选择年龄
- (void)selectAge:(UITapGestureRecognizer*)tap
{
    NSString *nowTimeStr = [NSDate stringFromDate:[NSDate date] withFormatter:DataFormatter_Date];
    WEAKSELF
    [[InterfaceHUDManager sharedInstance] showPickerWithTitle:LocalizedStr(age)
                                               PickerShowType:PickerShowType_Date
                                           defaultSelectedStr:_birthdayStr
                                            pickerCancelBlock:^(NSString *pickedContent, NSArray *idsArray) {
        
    } pickerConfirmBlock:^(NSString *pickedContent, NSArray *idsArray) {
        STRONGSELF
        //2015-11-22
        NSString *noticeStr = LocalizedStr(age_error);
        
        if ([pickedContent isAbsoluteValid] && ![pickedContent isEqualToString:nowTimeStr])
        {
            _birthdayStr = pickedContent;
            
            NSArray *selectTimeArray = [pickedContent componentsSeparatedByString:@"-"];
            if ([selectTimeArray isAbsoluteValid] && selectTimeArray.count > 2)
            {
                NSInteger selectYear = [[selectTimeArray objectAtIndex:0] integerValue];
                NSInteger selectMonth = [[selectTimeArray objectAtIndex:1] integerValue];
                NSInteger selectDay = [[selectTimeArray objectAtIndex:2] integerValue];
                
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
                NSInteger currentYear  = [components year];
                NSInteger currentMonth = [components month];
                NSInteger currentDay   = [components day];
                
                BOOL selectRightDate = YES;
                if (currentYear < selectYear)
                {
                    selectRightDate = NO;
                }
                /*
                else
                {
                    if (currentMonth < selectMonth)
                    {
                        selectRightDate = NO;
                    }
                    else
                    {
                        if (currentDay < selectDay) {
                            selectRightDate = NO;
                        }
                    }
                }
                */
                if (selectRightDate)
                {
                    // 计算年龄
                    NSInteger iAge = currentYear - selectYear - 1;
                    if ((currentMonth > selectMonth) || (currentMonth == selectMonth && currentDay >= selectDay)) {
                        iAge++;
                    }
                    
                    strongSelf->_ageString = [NSString stringWithInt:iAge];
                    strongSelf->_ageLB.text = strongSelf->_ageString;
                }
                else
                {
                   [strongSelf showHUDInfoByString:noticeStr];
                }
            }
        }
        else
        {
            [strongSelf showHUDInfoByString:noticeStr];
        }
    }];
}

- (void)roleBtnTouch:(UIButton*)btn
{
    if (btn.selected)
        return;
    if (_lastSelectRoleBtn) {
        _lastSelectRoleBtn.selected = NO;
    }
    btn.selected = YES;
    _lastSelectRoleBtn = btn;
}

@end
