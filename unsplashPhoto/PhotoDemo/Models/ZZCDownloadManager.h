//
//  ZZCDownloadManager.h
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCDownloadManager : NSObject
+ (ZZCDownloadManager *)sharedManager;
- (void)getPhotosWithPage:(NSInteger)page
                  prePage:(NSInteger)perPage
                  success:(void (^)(id _Nullable responseObject))success
                  failure:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
