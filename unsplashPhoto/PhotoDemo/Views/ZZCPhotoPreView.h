//
//  ZZCPhotoPreView.h
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZCPhotoModel;

@interface ZZCPhotoPreView : UIView

@property (nonatomic, strong) ZZCPhotoModel *photoModel;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect preBeginFrame;

- (void)showWithAnimate:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
