//
//  ZZCWaterfallFlowLayout.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ZZCWaterfallFlowLayout.h"

@implementation ZZCWaterfallFlowLayout
- (instancetype)init {
    if (self = [super init]) {
        _columnHeightArray = [NSMutableArray array];
        _cellInfoDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < columnCount; i++) {
            [_columnHeightArray addObject:@(0)];
        }
    }
    return self;
}

#pragma mark - 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    
    //设置代理为主控制器
    self.delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    
    //获取cell的个数
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    
    if (_cellCount == 0) {
        return;
    }
    [_columnHeightArray removeAllObjects];
    for (int i = 0; i < columnCount; i++) {
        [_columnHeightArray addObject:@(0)];
    }
    
    //循环调用layoutForItemAtIndexPath方法，为每个cell布局，将indexPath传入，作为布局字典的key
    //layoutAttributesForItemAtIndexPath方法的实现，这里用到了一个布局字典，其实就是将每个cell的位置信息与indexPath相对应，将它们放到字典中，方便后面视图的检索
    for (int i = 0; i < _cellCount; i++) {
        [self layoutItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
}

#pragma mark - 将各个cell的frame等信息放入字典中
- (void)layoutItemAtIndexPath:(NSIndexPath*)indexPath {
    CGSize itemSize = [self.delegate collectionView:self.collectionView
                                             layout:self
                             sizeForItemAtIndexPath:indexPath];
    
    //比较列高数组的数据,找出最小高度列
    float colIndex = 0;
    float shortestHeight = [[self.columnHeightArray objectAtIndex:colIndex] floatValue];
    for (int i = 1 ; i < columnCount; i++) {
        float height = [[self.columnHeightArray objectAtIndex:i] floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            colIndex = i;
        }
    }
    
    //确定当前cell的frame
    CGRect frame = CGRectMake(edgeInsets.left + colIndex * (kColSpacing + itemSize.width),
                              edgeInsets.top + shortestHeight,
                              itemSize.width,
                              itemSize.height);
    //更新列高数组的数据
    [self.columnHeightArray replaceObjectAtIndex:colIndex
                                      withObject:@(CGRectGetMaxY(frame))];
    //设置cell信息的字典,每个frame对应一个indexPath
    [self.cellInfoDict setObject:indexPath
                          forKey:NSStringFromCGRect(frame)];
}

#pragma mark - 返回可见范围内cell的indexPath
- (NSArray*)indexPathsOfItem:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *rectStr in _cellInfoDict) {
        CGRect cellRect = CGRectFromString(rectStr);
        if (CGRectIntersectsRect(cellRect, rect)) {
            NSIndexPath *indexPath = _cellInfoDict[rectStr];
            [array addObject:indexPath];
        }
    }
    return array;
}

//这个方法返回的一定数量的cell的属性的数组，一定数量指的是出现在屏幕中的cell，不包括滑动出现的cell
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *indexPaths = [self indexPathsOfItem:rect];
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [muArr addObject:attribute];
    }
    return muArr;
}

//代理方法返回每个cell属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    for (NSString *rectStr in self.cellInfoDict) {
        if ([self.cellInfoDict valueForKey:rectStr] == indexPath) {
            attributes.frame = CGRectFromString(rectStr);
        }
    }
    return attributes;
}

- (CGSize)collectionViewContentSize {
    CGSize size = self.collectionView.frame.size;
    float maxHeight = [[self.columnHeightArray objectAtIndex:0] floatValue];
    for (int i = 1; i < columnCount; i++) {
        float height = [[self.columnHeightArray objectAtIndex:i] floatValue];
        if (height > maxHeight) {
            maxHeight = height;
        }
    }
    size.height = maxHeight + 10;
    return size;
}
@end
