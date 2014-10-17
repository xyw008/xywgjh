//
//  PickAlertTypeManager.h
//  Find lawyer
//
//  Created by leo on 14-10-17.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PickerBlock) (NSString *selectStr);

@interface PickerAlertTypeManager : NSObject

AS_SINGLETON(PickerAlertTypeManager);

- (void)showPickerWithTitle:(NSString *)title
            dataSourceArray:(NSArray*)array
          pickerCancelBlock:(PickerBlock)pickerCancelBlock
         pickerConfirmBlock:(PickerBlock)pickerConfirmBlock;


@end
