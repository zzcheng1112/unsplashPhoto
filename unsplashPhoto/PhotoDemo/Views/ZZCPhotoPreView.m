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

static CGFloat const kPreViewLeft = 30;
static CGFloat const kPreViewTop = 30;

static CGFloat const kCloseButtonWidth = 19;
static CGFloat const kCloseButtonRight = 11;
static CGFloat const kCloseButtonTop = 9;
static CGFloat const kCloseButtonAdditionalWidth = 20;

@interface ZZCPhotoPreView ()
@property (nonatomic, strong) UIImageView *preImageView;
@end

@implementation ZZCPhotoPreView {
    UIVisualEffectView *_effectView;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIButton *_closeButton;
    CGRect _preEndFrame;
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
        //        _tapGestureRecognizer.delegate = self;
        [_effectView addGestureRecognizer:_tapGestureRecognizer];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"close_press"] forState:UIControlStateHighlighted];
        [self addSubview:_closeButton];
        
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
    
    CGFloat imageViewWidth = deviceWidth - 2 * kPreViewLeft;
    CGFloat imageViewHeight = deviceHeight - 2 * kPreViewTop - LL_StatusBarHeight - LL_TabbarSafeBottomMargin;
    
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
        [UIView animateWithDuration:0.25 animations:^{
            self.preImageView.alpha = 1.0;
            self.preImageView.frame = _preEndFrame;
        } completion:^(BOOL finished) {
            //            [UIView animateWithDuration:0.2 animations:^{
            //                _shareView.alpha = 1;
            //            } completion:nil];
        }];
    } else {
        self.preImageView.alpha = 1.0;
        self.preImageView.frame = _preEndFrame;
    }
}

- (void)hideWithAnimate:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.preImageView.alpha = 0;
            self.preImageView.frame = _preBeginFrame;
        } completion:^(BOOL finished) {
            [self.preImageView removeFromSuperview];
            self.preImageView = nil;
            [self removeFromSuperview];
        }];
    } else {
        [self.preImageView removeFromSuperview];
        self.preImageView = nil;
        [self removeFromSuperview];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer*)recognizer {
    [self actionClose];
}
- (void)actionClose {
    [self hideWithAnimate:YES];
}
#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    NSLog(@"%@",gestureRecognizer);
//    if (gestureRecognizer == _tapGestureRecognizer) {
//        return [touch.view isEqual:_effectView];
//    }
//    return YES;
//}

@end
