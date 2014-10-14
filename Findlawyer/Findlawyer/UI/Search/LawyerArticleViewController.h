//
//  LawyerArticleViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "FLBaseViewController.h"

@interface LawyerArticleViewController : FLBaseViewController

@property (nonatomic)NSInteger * articleID;
@property (nonatomic,strong)NSDictionary * dicArticle;
@property (weak, nonatomic) IBOutlet UILabel *lbTitile;
@property (weak, nonatomic) IBOutlet UILabel *lbLaunchTime;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
