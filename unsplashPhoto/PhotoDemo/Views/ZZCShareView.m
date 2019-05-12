//
//  ZZCShareView.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ZZCShareView.h"
#import "UIColor+Hex.h"

static CGFloat kViewSpace = 20;
static CGFloat kViewWidth = 50;
static CGFloat kViewHeight = 30;

static CGFloat kLabelHeight = 20;
static CGFloat kLineLeft = 15;

@implementation ZZCShareView {
    NSMutableArray *_buttonArray;
    UILabel *_label;
    UIView * _leftLineView;
    UIView * _rightLineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _buttonArray = [NSMutableArray array];
        [self createShareViews];
    }
    return self;
}

-(void)createShareViews {
    _leftLineView  = [[UIView alloc] init];
    _leftLineView.backgroundColor = [UIColor blackColor];
    [self addSubview:_leftLineView];
    
    _rightLineView  = [[UIView alloc] init];
    _rightLineView.backgroundColor = [UIColor blackColor];
    [self addSubview:_rightLineView];
    
    _label = [[UILabel alloc] init];
    _label.text = @"分享到";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:15];
    [self addSubview:_label];
    
    NSArray *textArray = @[@"复制", @"保存", @"QQ", @"微信"];
    for (int i = 0; i < 4; i++) {
        UIButton *viewButton = [[UIButton alloc] initWithFrame:CGRectZero];
        viewButton.tag = 100 + i;
        [viewButton setTitle:textArray[i] forState:UIControlStateNormal];
        viewButton.layer.cornerRadius = 4;
        viewButton.layer.masksToBounds = YES;
        viewButton.layer.borderColor = [[UIColor colorWithHexString:@"#007AFF"] CGColor];
        viewButton.layer.borderWidth = 1;
        [viewButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [viewButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewButton];
        [_buttonArray addObject:viewButton];
    }
}
- (void)setFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero) || CGRectEqualToRect(frame, self.frame)) {
        return;
    }
    [super setFrame:frame];
    CGFloat height = CGRectGetHeight(frame);
    CGFloat width = CGRectGetWidth(frame);
    
    NSDictionary *attributes = @{NSFontAttributeName:_label.font};
    CGFloat labelWidth = [_label.text sizeWithAttributes:attributes].width + 8;
    _label.frame = CGRectMake((width - labelWidth) * 0.5, 0, labelWidth, kLabelHeight);

    _leftLineView.frame = CGRectMake(kLineLeft, 10, CGRectGetMinX(_label.frame) - kLineLeft, 1.0 / [UIScreen mainScreen].scale);
    
    _rightLineView.frame = CGRectMake(CGRectGetMaxX(_label.frame), 10, CGRectGetWidth(_leftLineView.frame), 1.0 / [UIScreen mainScreen].scale);
    
    CGFloat originX = (CGRectGetWidth(frame) - kViewSpace * 3 - kViewWidth * 4) / 2;
    for (int i = 0; i < _buttonArray.count; i++) {
        [_buttonArray[i] setFrame:CGRectMake(originX + (kViewWidth + kViewSpace) * i, height - kViewHeight, kViewWidth, kViewHeight)];
    }
}
- (void)buttonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:button];
    }
}
@end
