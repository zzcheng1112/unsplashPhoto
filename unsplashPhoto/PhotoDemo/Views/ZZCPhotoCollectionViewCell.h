//
//  ZZCPhotoCollectionViewCell.h
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZCPhotoModel;

@interface ZZCPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) ZZCPhotoModel *model;
- (UIImage *)getImage;

@end

NS_ASSUME_NONNULL_END
