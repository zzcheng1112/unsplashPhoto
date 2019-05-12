//
//  ViewController.m
//  unsplashPhoto
//
//  Created by MrZhou on 2019/5/12.
//  Copyright © 2019 MrZhou. All rights reserved.
//

#import "ViewController.h"
#import "ZZCPhotoCollectionViewCell.h"
#import "ZZCWaterfallFlowLayout.h"
#import "ZZCPhotoModel.h"
#import "ZZCPhotoPreView.h"
#import "ZZCDownloadManager.h"
#import "ConstantUI.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <MJExtension/MJExtension.h>
#import "MBProgressHUD.h"

static NSString *kCellIdentifier = @"photoCellId";
static const NSInteger kFirstScreenPhotoStepCount = 30; //每次刷新photo的张数
static const NSInteger kPhotoStepCount = 15; //每次刷新photo的张数
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,assign) BOOL isLoadingData;
@property (nonatomic ,assign) NSUInteger currentPage; //当前页数
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation ViewController {
    BOOL _isFirstLoad;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"ZZC的相册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    
    ZZCWaterfallFlowLayout *layout = [[ZZCWaterfallFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight, self.view.width, self.view.height - LL_StatusBarAndNavigationBarHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[ZZCPhotoCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.collectionView];
    _currentPage = 1;
    _isFirstLoad = YES;
    [self getDataFromService];
    _isFirstLoad = NO;
}

- (void)showToast:(NSString *)text {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = text;
    _hud.removeFromSuperViewOnHide = YES;
}
- (void)getDataFromService {
    if (_isLoadingData)
        return;
    _isLoadingData = YES;
    if (_isFirstLoad) {
        [self showToast:@"加载中,请稍后"];
    }
    NSUInteger prePage = self.dataArray.count ? kPhotoStepCount : kFirstScreenPhotoStepCount;
    
    __weak typeof(self)weakSelf = self;
    [[ZZCDownloadManager sharedManager] getPhotosWithPage:_currentPage prePage:prePage success:^(id  _Nullable responseObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSArray *result = (NSArray*)responseObject;
        for (NSDictionary *dict in result) {
            ZZCPhotoModel *model = [ZZCPhotoModel mj_objectWithKeyValues:dict];
            [strongSelf.dataArray addObject:model];
        }
        strongSelf.isLoadingData = NO;
        strongSelf.currentPage ++;
        if (strongSelf.hud) {
            [strongSelf.hud hide:YES];
        }
        [strongSelf.collectionView reloadData];
    
    } failure:^(NSError * _Nonnull error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isLoadingData = NO;
        if (strongSelf.hud) {
            [strongSelf.hud hide:YES];
        }
    }];
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZCPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    [self checkLoadForIndexPath:indexPath];
    return cell;
}


#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZCPhotoCollectionViewCell *cell = (ZZCPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ZZCPhotoModel *photoModle = self.dataArray[indexPath.item];
    if (photoModle) {
        ZZCPhotoPreView *preView = [[ZZCPhotoPreView alloc] init];
        preView.image = [cell getImage];
        CGRect frame = [collectionView convertRect:cell.frame toView:self.view];
        preView.preBeginFrame = frame;
        preView.photoModel = photoModle;
        [preView showWithAnimate:YES];
    }
}
#pragma mark - 设置item的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.bounds.size.width - kColSpacing * (columnCount + 1)) / columnCount;
    ZZCPhotoModel *model = self.dataArray[indexPath.item];
    CGFloat height = model.height.floatValue / model.width.floatValue * width;
    CGSize newSize = CGSizeMake(width, height);
    return newSize;
}

- (void)checkLoadForIndexPath:(NSIndexPath *)indexPath{
    if (kPhotoStepCount + indexPath.item >= self.dataArray.count) {
        [self getDataFromService];
    }
    
}
@end
