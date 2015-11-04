//
//  RefreshTabView.m
//  zmt
//
//  Created by apple on 14-2-19.
//  Copyright (c) 2014年 com.ygsoft. All rights reserved.
//

#import "UIRefreshTabView.h"

@implementation UIRefreshTabView

@synthesize srRefreshView = _srRefreshView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame tag:(int)tag dataSoure:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate srRefreshViewDelegate:(id<SRRefreshDelegate>)srRefreshViewDelegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.tag = tag;
        self.delegate = delegate;
        self.dataSource = dataSource;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 粘泥下拉刷新
        self.srRefreshView = [[SRRefreshView alloc] init];
        _srRefreshView.delegate = srRefreshViewDelegate;
        _srRefreshView.upInset = 5.0;
        _srRefreshView.slimeMissWhenGoingBack = YES;
        
        _srRefreshView.slime.viscous = 55.0; // 粘性
        _srRefreshView.slime.radius = 15.0; // 半径
        _srRefreshView.slime.shadowType = SRSlimeFillShadow;
        
        _srRefreshView.slime.bodyColor = HEXCOLOR(0x80CAEE);
        _srRefreshView.slime.skinColor = [UIColor whiteColor];
        _srRefreshView.slime.lineWith = 1.0;
        _srRefreshView.slime.shadowBlur = 3.0;
        _srRefreshView.slime.shadowColor = HEXCOLOR(0x80CAEE);
        
        [self addSubview:_srRefreshView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
