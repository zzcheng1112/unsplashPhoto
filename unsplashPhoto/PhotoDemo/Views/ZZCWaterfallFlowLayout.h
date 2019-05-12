//
//  ZZCWaterfallFlowLayout.h
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat kColSpacing = 10;//列与列之间的距离
static CGFloat const columnCount = 2;//列的数量
static UIEdgeInsets edgeInsets = {10,10,10,10};//内边距

@interface ZZCWaterfallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic ,strong) NSMutableArray *columnHeightArray;//列高存放数组
@property (nonatomic ,strong) NSMutableDictionary *cellInfoDict;//cell位置信息字典
@property (nonatomic ,assign) NSInteger cellCount;//cell总个数

@end

NS_ASSUME_NONNULL_END
