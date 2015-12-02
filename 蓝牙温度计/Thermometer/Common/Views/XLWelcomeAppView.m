//
//  WelcomeAppView.m
//  Vmei
//
//  Created by leo on 15/10/10.
//  Copyright © 2015年 com.vmei. All rights reserved.
//

#import "XLWelcomeAppView.h"
#import "AppDelegate.h"

#define kImageStartTag 10000
#define kBtnStartTag 20000


@interface WelcomeBgView : UIView
{
//    UIImageView     *_leftIV;
//    UIImageView     *_centerIV;
//    UIImageView     *_rigthIV;
    
    UIImageView     *_firstIV;
    UIImageView     *_lastIV;
    UIButton        *_goInAppBtn;
    
    CGPoint         _startPoint;
    CGPoint         _lastPoint;
    
    NSArray         *_imageArray;
    NSInteger       _nowShowIndex;//现在显示的图片index
    
    BOOL            _autoHidden;//自动隐藏
    
    
}

@property (nonatomic,strong)welcomeFinishCallBack     callBack;

@property (nonatomic,assign)BOOL                      isAboutType;//关于类型

@end

////////////////////////////////////////////////////////

@implementation WelcomeBgView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray*)imageArray callBack:(welcomeFinishCallBack)callBack
{
    self = [super initWithFrame:frame];
    if (self) {
//        _leftIV = [[UIImageView alloc] initWithFrame:CGRectMake(-self.width, 0, self.width, self.height)];
//        
//        _centerIV = [[UIImageView alloc] initWithFrame:self.bounds];
//        
//        _rigthIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
//        
//        [self addSubview:_leftIV];
//        [self addSubview:_centerIV];
//        [self addSubview:_rigthIV];
//        
//        _leftIV.backgroundColor = [UIColor redColor];
//        _centerIV.backgroundColor = [UIColor greenColor];
//        _rigthIV.backgroundColor = [UIColor yellowColor];
        
        //self.backgroundColor = [UIColor blackColor];
        
        _autoHidden = NO;
        
        _imageArray = imageArray;
        _callBack = callBack;
        
        for (NSInteger i=0; i<imageArray.count; i++)
        {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.width, 0, self.width, self.height)];
            iv.tag = kImageStartTag + i;
            iv.image = [UIImage imageNamed:_imageArray[i]];
            [self addSubview:iv];
            
            if (0==i)
                _firstIV = iv;
            
            if (imageArray.count - 1 == i)
            {
                
                if (_autoHidden)
                {
                    CGSize btnSize = CGSizeMake(DynamicWidthValue640(476), DynamicWidthValue640(100));
                    CGFloat bottomSpace = DynamicWidthValue640(65);
                    _goInAppBtn = [[UIButton alloc] initWithFrame:CGRectMake((iv.width - btnSize.width)/2, iv.height - bottomSpace - btnSize.height, btnSize.width, btnSize.height)];
                    [iv addSubview:_goInAppBtn];
                }
                else
                {
                    _lastIV = iv;
                    CGFloat margin = 60;
                    CGFloat heigth = 40;
                    NSArray *titleArray = @[@"注册",@"登录",@"客人模式"];
                    for (NSInteger j=0; j<titleArray.count; j++)
                    {
                        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(margin, DynamicWidthValue640(720) + (heigth+ 8) * j, iv.width - margin * 2, heigth)];
                        btn.tag = kBtnStartTag + j;
                        btn.backgroundColor = [UIColor clearColor];
                        btn.titleLabel.font = SP16Font;
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn setTitle:titleArray[j] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
                        ViewBorderRadius(btn, 5, LineWidth, [UIColor whiteColor]);
                        [iv addSubview:btn];
                    }
                }
                
                
            }
        }
        _nowShowIndex = 0;
    }
    return self;
}

- (void)setIsAboutType:(BOOL)isAboutType
{
    _isAboutType = isAboutType;
    for (NSInteger i=0; i<3; i++) {
        UIButton *btn = (UIButton*)[_lastIV viewWithTag:kBtnStartTag + i];
        if (i != 1) {
            btn.hidden = YES;
        }
        else
        {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn setTitle:@"确定" forState:UIControlStateNormal];
            }
        }
    }
    
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _startPoint = point;
    _lastPoint = point;
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (!_autoHidden)
    {
        for (NSInteger i=0; i<3; i++)
        {
            UIButton *btn = [_lastIV viewWithTag:kBtnStartTag + i];
            if (CGRectContainsPoint(btn.frame, point))
            {
                if (touch.tapCount == 1)
                {
                    if (_callBack)
                    {
                        _callBack(btn.tag - kBtnStartTag);
                    }
                    [self scrollPageAnimate];
                    return;
                }
            }
        }
    }
    
    if (CGRectContainsPoint(_goInAppBtn.frame, point))
    {
        if (touch.tapCount == 1)
        {
            _nowShowIndex++;
        }
    }
    else
    {
        CGFloat allMoveX = point.x - _startPoint.x;
        
        if (allMoveX < 0)
        {
            //最后一张
            if (_nowShowIndex == _imageArray.count - 1 && fabs(allMoveX) > 85)
            {
                if (_autoHidden) {
                    //不用自动隐藏就屏蔽这句代码
                    _nowShowIndex++;
                }
                
            }
            else if (fabs(allMoveX) > 60 && _nowShowIndex < _imageArray.count - 1)
            {
                _nowShowIndex++;
            }
        }
        else
        {
            if (allMoveX > 60 && _nowShowIndex != 0)
            {
                _nowShowIndex--;
            }
        }
    }
    
    [self scrollPageAnimate];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat moveX = point.x - _lastPoint.x;
    
    //DLog(@"start.x = %lf point.x = %lf  point.y = %lf  moveX = %lf",_startPoint.x,point.x,point.y,moveX);
    
    if (moveX > 0 && 0 == _nowShowIndex && _firstIV.frameOriginX >= 0)
    {
        
    }
    else
    {
        if (_autoHidden)
        {
            if (_firstIV.frameOriginX + moveX > 0)
            {
                moveX = 0 - _firstIV.frameOriginX;
            }
            for (UIView *subView in self.subviews)
            {
                subView.frameOriginX += moveX;
            }
        }
        else
        {
            //最后一张不让再继续往左拖动
            if (_nowShowIndex == _imageArray.count - 1 && _firstIV.frameOriginX <= -(_firstIV.width * (_imageArray.count - 1)))
            {
                
            }
            else
            {
                if (_firstIV.frameOriginX + moveX > 0)
                {
                    moveX = 0 - _firstIV.frameOriginX;
                }
                for (UIView *subView in self.subviews)
                {
                    subView.frameOriginX += moveX;
                }
            }
        }
    }
    _lastPoint = point;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - btn touch
- (void)btnTouch:(UIButton*)btn
{
    if (_callBack) {
        _callBack(btn.tag - kBtnStartTag);
    }
}


#pragma mark -

- (void)scrollPageAnimate
{
    WEAKSELF
    [UIView animateWithDuration:AnimationShowTime
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (UIView *subView in self.subviews)
                         {
                             subView.frameOriginX = (subView.tag - kImageStartTag - _nowShowIndex) * subView.width;
                         }
                     }
                     completion:^(BOOL finished) {
                         STRONGSELF
                         if (_nowShowIndex == _imageArray.count && strongSelf->_callBack)
                         {
                             if (_autoHidden)
                             {
                                 [strongSelf removeFromSuperview];
                                 strongSelf->_callBack(-1);
                             }
                         }
                     }];
}

@end


////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

static XLWelcomeAppView *welcomeView;

@interface XLWelcomeAppView ()
{
    WelcomeBgView           *_bgView;
    welcomeFinishCallBack   _callBack;
}

@end

@implementation XLWelcomeAppView

+ (void)showWelcomeImage:(NSArray *)imageArray callBack:(welcomeFinishCallBack)callBack
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    welcomeView = [[XLWelcomeAppView alloc] initSuperView:appDelegate.window ImageArray:imageArray callBack:callBack];
    
    //welcomeView = [[XLWelcomeAppView alloc] initImageArray:imageArray callBack:callBack];
}

+ (XLWelcomeAppView*)showSuperView:(UIView *)superView welcomeImage:(NSArray *)imageArray callBack:(welcomeFinishCallBack)callBack
{
    if (!superView)
    {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        superView = appDelegate.window;
    }
    
    welcomeView = [[XLWelcomeAppView alloc] initSuperView:superView ImageArray:imageArray callBack:callBack];
    return welcomeView;
}


- (instancetype)initSuperView:(UIView*)superView ImageArray:(NSArray*)imageArray callBack:(welcomeFinishCallBack)callBack
{
    self = [super init];
    if (self) {
        _callBack = callBack;
        
        WEAKSELF
        _bgView = [[WelcomeBgView alloc] initWithFrame:superView.bounds imageArray:imageArray callBack:^(NSInteger touchBtnIndex){
            STRONGSELF
            if (strongSelf && strongSelf->_callBack) {
                strongSelf->_callBack(touchBtnIndex);
            }
            //[weakSelf removeSelf];
        }];
        [superView addSubview:_bgView];
    }
    return self;
}

//- (instancetype)initImageArray:(NSArray*)imageArray callBack:(welcomeFinishCallBack)callBack
//{
//    self = [super init];
//    if (self) {
//        _callBack = callBack;
//        
//        
//        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//        
//        WEAKSELF
//        _bgView = [[WelcomeBgView alloc] initWithFrame:appDelegate.window.bounds imageArray:imageArray callBack:^{
//            STRONGSELF
//            if (strongSelf && strongSelf->_callBack) {
//                strongSelf->_callBack();
//            }
//            [weakSelf removeSelf];
//        }];
//        [appDelegate.window addSubview:_bgView];
//    }
//    return self;
//}

- (void)removeSelf
{
    [_bgView removeFromSuperview];
    _bgView = nil;
    
    welcomeView = nil;
}

- (void)setIsAboutType:(BOOL)isAboutType
{
    _bgView.isAboutType = isAboutType;
}

@end
