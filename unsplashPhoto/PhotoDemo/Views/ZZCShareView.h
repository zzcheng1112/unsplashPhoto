//
//  ZZCShareView.h
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    ZZCShareButtonCopy = 100,
    ZZCShareButtonSave,
    ZZCShareButtonQQ,
    ZZCShareButtonWX,
} ZZCShareButtonTag;

@protocol ZZCShareViewDelegate <NSObject>
- (void)buttonClick:(UIButton *)button;
@end

@interface ZZCShareView : UIView
@property (nonatomic, weak) id<ZZCShareViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
