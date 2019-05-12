//
//  ZZCAlertController.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ZZCAlertController.h"
#import "UIColor+Hex.h"


@implementation ZZCAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message
                              firstTitle:(NSString *)firstTitle
                             secondTitle:(NSString *)secondTitle
                             firstAction:(void (^)(UIAlertAction *action))firstAction
                            secondAction:(void (^)(UIAlertAction *action))secondAction{
    
    ZZCAlertController *alertController = [ZZCAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.noBoldButtonTitle = firstTitle;
    alertController.boldButtonTitle = secondTitle;//默认选中第二个加粗
    
    if (firstTitle) {
        UIAlertAction* alertAction1 = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:firstAction];
        [alertController addAction:alertAction1];
    }
    
    if (secondTitle) {
        UIAlertAction* alertAction2 = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:secondAction];
        [alertController addAction:alertAction2];
    }
    return alertController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.tintColor) {
        self.tintColor = [UIColor colorWithHexString:@"#007AFF"];
    }
    self.view.tintColor = _tintColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.noBoldButtonTitle) {
        UILabel *tmpLabel = [self findLabel:self.view prefix:self.noBoldButtonTitle];
        tmpLabel.font = [UIFont systemFontOfSize:tmpLabel.font.pointSize];
        tmpLabel.tintColor = _tintColor;
    }
    
    if (self.boldButtonTitle) {
        UILabel *tmpLabel = [self findLabel:self.view prefix:self.boldButtonTitle];
        tmpLabel.font = [UIFont boldSystemFontOfSize:tmpLabel.font.pointSize];
    }
}

- (UILabel *)findLabel:(UIView *)aView prefix:(NSString *)prefix {
    UILabel *tmpLabel = (UILabel*)aView;
    if ([tmpLabel isKindOfClass:[UILabel class]] && [tmpLabel.text hasPrefix:prefix]){
        return tmpLabel;
    } else {
        for (UIView *subView in aView.subviews) {
            tmpLabel = [self findLabel:subView prefix:prefix];
            if (tmpLabel) {
                return tmpLabel;
            }
        }
    }
    return nil;
}


- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;

    UIViewController *rootVC = keyWindow.rootViewController;
    
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    
    [rootVC presentViewController:self animated:YES completion:^{
        UIView *topView = self.view;
        UIWindow *window = self.view.window;
        while(topView.superview != window) {
            topView = topView.superview;
        }
        [window bringSubviewToFront:topView];
    }];
}
@end
