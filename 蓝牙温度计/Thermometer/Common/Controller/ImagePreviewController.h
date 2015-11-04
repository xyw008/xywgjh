//
//  ImagePreviewController.h
//  JmrbNews
//
//  Created by swift on 14/12/6.
//
//

#import "BaseNetworkViewController.h"

@interface ImagePreviewController : BaseNetworkViewController

@property (nonatomic, copy) NSString  *titleStr;
@property (nonatomic, strong) NSArray *imageItemsArray;     // ImageItem数组

@end

@interface ImageItem : NSObject

- (id)initWithImageUrlOrName:(NSString *)urlOrName imageDesc:(NSString *)desc;

@property (nonatomic, copy) NSString *imageUrlOrNameStr;    // 图片url或者图片名
@property (nonatomic, copy) NSString *imageDescStr;         // 图片对应的图注描述

@end
