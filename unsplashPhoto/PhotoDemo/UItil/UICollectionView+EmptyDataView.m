//
//  UICollectionView+EmptyDataView.m
//  unsplashPhoto
//
//  Created by larkdata on 2019/5/14.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "UICollectionView+EmptyDataView.h"
#import <objc/runtime.h>

@implementation UICollectionView (EmptyDataView)

static char *EmptyDataView;

+(void)load{
    Method originMethod = class_getInstanceMethod(self, @selector(reloadData));
    Method newMethod = class_getInstanceMethod(self, @selector(ZZC_reloadData));
    method_exchangeImplementations(originMethod, newMethod);
}

-(void)ZZC_reloadData{
    [self ZZC_reloadData];
    [self loadEmptyDataView];
}

-(void)loadEmptyDataView{
    id<UICollectionViewDataSource> dataSource = self.dataSource;
    NSInteger section = ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)] ? [dataSource numberOfSectionsInCollectionView:self] : 1);
    NSInteger rows = 0;
    for (int i = 0; i < section; i++) {
        rows += [dataSource collectionView:self numberOfItemsInSection:i];
    }
    if (rows == 0) {
        self.emptyDataView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - 201 * 0.5, 200, 402*0.5, 410*0.5)];
        self.emptyDataView.image = [UIImage imageNamed:@"emptyData.png"];
        [self addSubview:self.emptyDataView];
    }else{
        self.emptyDataView.hidden = YES;
    }
}

#pragma mark - getter and setter
//给分类添加属性,不会自动生成setter和getter,需要runtime关联
-(void)setEmptyDataView:(UIImageView *)emptyDataView{
    objc_setAssociatedObject(self, &EmptyDataView, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView*)emptyDataView{
    return objc_getAssociatedObject(self, &EmptyDataView);
}






@end
