//
//  ZZCPhotoPreView.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ZZCPhotoPreView.h"
#import "ZZCPhotoModel.h"
#import "YYImage.h"
#import "UIImageView+YYWebImage.h"
#import "ConstantUI.h"
#import "MBProgressHUD.h"
#import <Photos/Photos.h>
#import "ZZCAlertController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZZCShareView.h"

static CGFloat const kPreViewLeft = 30;
static CGFloat const kPreViewTop = 30;

static CGFloat const kCloseButtonWidth = 19;
static CGFloat const kCloseButtonRight = 11;
static CGFloat const kCloseButtonTop = 9;
static CGFloat const kCloseButtonAdditionalWidth = 20;

static CGFloat const kShareViewHeight = 60;
static CGFloat const kShareViewBottom = 50;

@interface ZZCPhotoPreView ()<ZZCShareViewDelegate>
@property (nonatomic, strong) UIImageView *preImageView;
@property (nonatomic, strong) ZZCShareView *shareView;
@property (nonatomic, assign) CGRect preEndFrame;
@end

@implementation ZZCPhotoPreView {
    UIVisualEffectView *_effectView;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIButton *_closeButton;
}

- (void)dealloc {
    _tapGestureRecognizer.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:beffect];
        [self addSubview:_effectView];
        
        //tap action
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [_effectView addGestureRecognizer:_tapGestureRecognizer];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"close_press"] forState:UIControlStateHighlighted];
        [self addSubview:_closeButton];
        
        _shareView = [[ZZCShareView alloc] initWithFrame:frame];
        _shareView.delegate = self;
        [self addSubview:_shareView];
        
        _preImageView = [[UIImageView alloc] init];
        _preImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_preImageView];
        
    }
    return self;
}
- (void)setImage:(UIImage *)image {
    _image = image;
    if (image) {
        _preImageView.image = image;
    }
}
- (void)setPhotoModel:(ZZCPhotoModel *)photoModel {
    _photoModel = photoModel;
    if (!_image) {
        [self.preImageView yy_setImageWithURL:[NSURL URLWithString:photoModel.urls[@"small"]] placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
        }];
    }
}
- (void)setSubViewsFrame {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat deviceWidth = screenSize.width;
    CGFloat deviceHeight = screenSize.height;
    
    _closeButton.frame = CGRectMake(deviceWidth - kCloseButtonWidth - kCloseButtonRight - kCloseButtonAdditionalWidth, kCloseButtonTop + LL_StatusBarHeight, kCloseButtonWidth + kCloseButtonAdditionalWidth, kCloseButtonWidth + kCloseButtonAdditionalWidth);
    
    _effectView.frame = self.bounds;
    
    _shareView.frame = CGRectMake(0, deviceHeight - LL_TabbarSafeBottomMargin - kShareViewBottom - kShareViewHeight, deviceWidth, kShareViewHeight);
    CGFloat imageViewWidth = deviceWidth - 2 * kPreViewLeft;
    CGFloat imageViewHeight = CGRectGetMinY(_shareView.frame) - 2 * kPreViewTop - LL_StatusBarHeight;
    
    _preEndFrame = CGRectMake(kPreViewLeft, LL_StatusBarHeight + kPreViewTop, imageViewWidth, imageViewHeight);
}

- (void)showWithAnimate:(BOOL)animated {
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [keyWindow addSubview:self];
    self.frame = keyWindow.bounds;
    [self setSubViewsFrame];
    
    if (animated) {
        _effectView.frame = self.bounds;
        _preImageView.frame = _preBeginFrame;
        _preImageView.alpha = 0;
        _shareView.alpha = 0;
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.preImageView.alpha = 1.0;
            strongSelf.preImageView.frame = strongSelf.preEndFrame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                __strong typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.shareView.alpha = 1;
            } completion:nil];
        }];
    } else {
        self.preImageView.alpha = 1.0;
        self.preImageView.frame = _preEndFrame;
    }
}

- (void)hideWithAnimate:(BOOL)animated {
    if (animated) {
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.15 animations:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.shareView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                __strong typeof(weakSelf)strongSelf = weakSelf;
                strongSelf.preImageView.alpha = 0;
                strongSelf.preImageView.frame = strongSelf.preBeginFrame;
            } completion:^(BOOL finished) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf removeFromSuperview];
            }];
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer*)recognizer {
    [self actionClose];
}
- (void)actionClose {
    [self hideWithAnimate:YES];
}

#pragma mark -shareView delegate
- (void)buttonClick:(UIButton *)button {
    switch (button.tag) {
        case ZZCShareButtonSave:
            [self actionSave];
            break;
        case ZZCShareButtonCopy:
            [self actionCopy];
            break;
        case ZZCShareButtonQQ:
            [self actionShareToQQ];
            break;
        case ZZCShareButtonWX:
            [self actionShareToWX];
            break;
        default:
            break;
    }
}
- (void)actionShareToQQ {
    [self showToast:@"即将支持,请先选择复制然后粘贴到QQ,或者保存到相册,从相册发送!" hideDelay:2];
}
- (void)actionShareToWX {
    [self showToast:@"即将支持,请先选择复制然后粘贴到微信,或者保存到相册,从相册发送!" hideDelay:2];
}
- (void)actionCopy {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSData *imageData = UIImagePNGRepresentation(self.preImageView.image);
    if ([imageData isKindOfClass:[NSNull class]] || imageData == nil) {
        [self showToast:@"当前网络异常，请稍后再试" hideDelay:2];
    } else {
        [pasteboard setData:imageData forPasteboardType:UIPasteboardTypeListImage[0]];
        [self showToast:@"已复制" hideDelay:2];
    }
}
- (void)actionSave {
    NSData *imageData = UIImagePNGRepresentation(self.preImageView.image);
    
    if ([imageData isKindOfClass:[NSNull class]] || imageData == nil) {
        [self showToast:@"当前网络异常，请稍后再试" hideDelay:2];
    } else {
        [self saveStillImage:self.preImageView.image];
    }
}
/**
 下载图片
 */
- (void)saveStillImage:(UIImage *)image {
    [self checkAndSaveMediaWithCompletion:^(BOOL hasAccess){
        if (hasAccess) {
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
        } else {
            NSError *error = [NSError errorWithDomain:ALAssetsLibraryErrorDomain code:ALAssetsLibraryDataUnavailableError userInfo:nil];
            [self image:image didFinishSavingWithError:error contextInfo:nil];
        }
        
    }];
}

- (void)checkAndSaveMediaWithCompletion:(void (^)(BOOL hasAccess))completion {
    PHAuthorizationStatus curStatus = [PHPhotoLibrary authorizationStatus];
    if (PHAuthorizationStatusDenied == curStatus || PHAuthorizationStatusRestricted == curStatus) {
        BOOL canOpen = [self canOpenSystemSettings];
        NSString *title = canOpen ? @"保存图片需要相册权限" : @"需要相册权限";
        NSString *message = canOpen ? @"" : @"为了正常使用相册存储图片，请去\n[设置]→[隐私]→[照片]\n开启权限";
        NSString *firstTitle = canOpen ? @"取消" : @"";
        NSString *secondTitle = canOpen ? @"一键开启" : @"知道了";
        
        [[ZZCAlertController alertControllerWithTitle:title message:message
                                           firstTitle:firstTitle secondTitle:secondTitle
                                          firstAction:nil
                                         secondAction:^(UIAlertAction *action) {
                                             if (canOpen) {
                                                 [ self openSystemSettings];
                                             }
                                         }] show];
    } else if (PHAuthorizationStatusNotDetermined == curStatus) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus _status) {
            if (_status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(YES);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(NO);
                    }
                });
            }
        }];
    } else {
        if (completion) {
            completion(YES);
        }
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *toastString = nil;
    if (error) {
        toastString = @"保存失败";
    } else {
        toastString = @"已保存到本地相册";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showToast:toastString hideDelay:2];
    });
}
- (void)showToast:(NSString *)text hideDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}
- (BOOL)canOpenSystemSettings {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (BOOL)openSystemSettings {
    if (iOS11) {
        [self openIOS11SystemSettings];
        return YES;
    }
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
- (void)openIOS11SystemSettings {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
        [application openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
@end
