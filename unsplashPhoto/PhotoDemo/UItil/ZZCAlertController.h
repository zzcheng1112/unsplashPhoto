//
//  ZZCAlertController.h
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCAlertController : UIAlertController
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
                              firstTitle:(NSString *)firstTitle
                             secondTitle:(NSString *)secondTitle
                             firstAction:(void (^)(UIAlertAction *action))firstAction
                            secondAction:(void (^)(UIAlertAction *action))secondAction;
- (void)show;


@property (nonatomic, copy) NSString *noBoldButtonTitle;
@property (nonatomic, copy) NSString *boldButtonTitle;
@property (nonatomic, strong) UIColor *tintColor;
@end

NS_ASSUME_NONNULL_END
