//
//  SearchView.h
//  Find lawyer
//
//  Created by kadis on 14-10-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchView;

@protocol SearchViewDelegate <NSObject>

- (void)SearchView:(SearchView*)view searchText:(NSString*)text;

@end


@interface SearchView : UIView
{
    __weak id<SearchViewDelegate>       _delegate;
}
@property (nonatomic,weak)id            delegate;

@end
