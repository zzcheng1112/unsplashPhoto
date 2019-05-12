//
//  ZZCPhotoModel.h
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCPhotoModel : NSObject

@property (nonatomic ,strong) NSDictionary *urls;
@property (nonatomic ,strong) NSNumber *width;
@property (nonatomic ,strong) NSNumber *height;

@end

NS_ASSUME_NONNULL_END
