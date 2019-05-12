//
//  ZZCDownloadManager.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ZZCDownloadManager.h"
#import <AFNetworking/AFNetworking.h>
static NSString *const kGetPhotoHost = @"https://api.unsplash.com";
static NSString *const clientIid = @"2a7d9b5d25818be1b53a11734d37de7493bc9db8f36d971313f54f37ad113830";

@implementation ZZCDownloadManager

+ (ZZCDownloadManager *)sharedManager {
    static ZZCDownloadManager *s_sharedManager = nil;
    @synchronized(self) {
        if (!s_sharedManager) {
            s_sharedManager = [[ZZCDownloadManager alloc] init];
        }
    }
    return s_sharedManager;
}

- (void)getPhotosWithPage:(NSInteger)page
                  prePage:(NSInteger)perPage
                  success:(void (^)(id _Nullable responseObject))success
                  failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *param = @{
                            @"page" : @(page),
                            @"per_page" : @(perPage),
                            @"client_id" : clientIid
                            };
    NSString *urlString = [NSString stringWithFormat:@"%@/photos", kGetPhotoHost];
    [manager GET:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
