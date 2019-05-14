//
//  ZZCPhotoCollectionViewCell.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ZZCPhotoCollectionViewCell.h"
#import "ZZCWaterfallFlowLayout.h"
#import "ZZCPhotoModel.h"
#import "YYImage.h"
#import "UIImageView+YYWebImage.h"
#import "ConstantUI.h"
#import <SDAutoLayout/SDAutoLayout.h>

#define CellWidth ((self.superview.bounds.size.width - kColSpacing * (columnCount + 1))/2)

@interface ZZCPhotoCollectionViewCell()

@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation ZZCPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RandColor;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self setUpUI];
    }
    return self;
}

- (void)setModel:(ZZCPhotoModel *)model {
    _model = model;
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:model.urls[@"small"]] placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
}

- (void)setUpUI {
    [self.contentView addSubview:self.imageView];
    self.imageView.sd_layout.leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomSpaceToView(self.contentView, 0);
}

#pragma mark - lazy initial
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}
- (UIImage *)getImage {
    return self.imageView.image;
}
@end
