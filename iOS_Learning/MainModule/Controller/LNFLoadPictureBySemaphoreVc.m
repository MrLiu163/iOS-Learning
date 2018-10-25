//
//  LNFLoadPictureBySemaphoreVc.m
//  iOS_Learning
//
//  Created by mrliu on 2018/10/24.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFLoadPictureBySemaphoreVc.h"
#import "LNFPictureLoadShowCollectionCell.h"

@interface LNFLoadPictureBySemaphoreVc ()

@property (nonatomic, strong) LNFCollectionViewDataSourceHelper *dataSourceHelper;
@property (nonatomic, strong) LNFCollectionViewDelegateHelper *delegateHelper;
@property (nonatomic, strong) UICollectionView *pictureCollectionView;

@end

@implementation LNFLoadPictureBySemaphoreVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    self.navigationItem.title = @"信号量请求队列";
    UIBarButtonItem *rightLoadItem_Order = [[UIBarButtonItem alloc] initWithTitle:@"顺序" style:UIBarButtonItemStylePlain target:self action:@selector(rightLoadItem_OrderAction:)];
    UIBarButtonItem *rightLoadItem_Disorder = [[UIBarButtonItem alloc] initWithTitle:@"乱序" style:UIBarButtonItemStylePlain target:self action:@selector(rightLoadItem_DisorderAction:)];
    self.navigationItem.rightBarButtonItems = @[rightLoadItem_Order, rightLoadItem_Disorder];
    NSArray<NSString *> *loadPicList = @[@"http://dingyue.nosdn.127.net/To375uHiC7RYuP8fPwbuV4buTMLRrGlaIcjHqbNz0L07c1540425164144.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/1ad6b00ee7ee4810975d33b1be4c517e.png", @"http://cms-bucket.nosdn.127.net/2018/10/23/85c14bc8ca4c4c08957cccf3f6becddf.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/25/6b889f78cd98483ab35a566f61675717.png", @"http://cms-bucket.nosdn.127.net/2018/10/25/04283175001f41a19727cec0eed857e2.png", @"http://cms-bucket.nosdn.127.net/2018/10/23/f4e1ccc84b32413abf5b2988a29177c9.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/23/8840fb799a3f44409a3e3ef6c2a67334.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/615d5325fd644093ad261bc987ecd441.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/f4d8580fea674ecbb25e10e69e4aec30.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/5f7c4366f61749e88060cce28da83480.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/ef2d7c320e9049099f0745a7bbba1339.jpeg", @"http://cms-bucket.nosdn.127.net/2018/10/24/98e7a978f74a4a659fe79aad5ff3e487.png", @"http://cms-bucket.nosdn.127.net/2018/10/23/a19d071eff0f4063becbde7b1499a11b.png", @"http://cms-bucket.nosdn.127.net/2018/10/22/e23f3d14e8084a209af319a55d95f7e6.jpeg"];
    
    LNFCollectionViewCellConfigureBlock cellConfigureBlock = ^(LNFPictureLoadShowCollectionCell *cell, NSObject *item) {
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    };
    LNFCollectionViewDidSelectItemConfigureBlock didSelectBlock = ^(NSIndexPath *indexPath) {
        
    };
    LNFCollectionViewDataSourceHelper *dataSourceHelper = [[LNFCollectionViewDataSourceHelper alloc] initWithItems:loadPicList cellIdentifier:kLNFUICollectionViewCellIndetifier configureCellBlock:cellConfigureBlock];
    self.dataSourceHelper = dataSourceHelper;
    LNFCollectionViewDelegateHelper *delegateHelper = [[LNFCollectionViewDelegateHelper alloc] init];
    delegateHelper.didSelectItemBlock = didSelectBlock;
    self.delegateHelper = delegateHelper;
    
    // 添加集合视图
    NSInteger everyLineCount = 3;
    CGFloat horizontalSpace = 10.0, verticalSpace = 10.0, itemWidth = (kLNFScreenWidth - horizontalSpace * everyLineCount) / everyLineCount, itemHeight = itemWidth;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *pictureCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = verticalSpace;
    layout.minimumInteritemSpacing = horizontalSpace;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:pictureCollectionView];
    pictureCollectionView.backgroundColor = [UIColor whiteColor];
    pictureCollectionView.dataSource = dataSourceHelper;
    pictureCollectionView.delegate = delegateHelper;
    [pictureCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self.view);
    }];
    // 注册cell
    [pictureCollectionView registerClass:[LNFPictureLoadShowCollectionCell class] forCellWithReuseIdentifier:kLNFUICollectionViewCellIndetifier];
    self.pictureCollectionView = pictureCollectionView;
    
}

- (void)rightLoadItem_OrderAction:(UIBarButtonItem *)item
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [self clearCellPicShow];
    
    NSMutableArray<NSBlockOperation *> *blockOperationList = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataSourceHelper.items.count; i++) {
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_semaphore_t semaphore_loadPic = dispatch_semaphore_create(0);
            NSString *picUrlStr = self.dataSourceHelper.items[i];
            dispatch_async(dispatch_get_main_queue(), ^{
                LNFPictureLoadShowCollectionCell *picCell = (LNFPictureLoadShowCollectionCell *)[self.pictureCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [picCell.picView sd_setImageWithURL:[NSURL URLWithString:picUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    kLNFLog(@"---->>>>%zd---顺序", i);
                    dispatch_semaphore_signal(semaphore_loadPic);
                }];
            });
            dispatch_semaphore_wait(semaphore_loadPic, DISPATCH_TIME_FOREVER);
        }];
        [blockOperationList addObject:blockOperation];
        
    }
    NSOperationQueue *childOperationQueue = [[NSOperationQueue alloc] init];
    for (int i = 0; i < blockOperationList.count; i++) {
        if (i < blockOperationList.count - 1) {
            NSBlockOperation *blockOperation_this = blockOperationList[i];
            NSBlockOperation *blockOperation_next = blockOperationList[i + 1];
            [blockOperation_next addDependency:blockOperation_this];
        }
    }
    [childOperationQueue addOperations:blockOperationList waitUntilFinished:NO];
}
- (void)rightLoadItem_DisorderAction:(UIBarButtonItem *)item
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [self clearCellPicShow];
    
    for (NSInteger i = 0; i < self.dataSourceHelper.items.count; i++) {
        NSString *picUrlStr = self.dataSourceHelper.items[i];
        LNFPictureLoadShowCollectionCell *picCell = (LNFPictureLoadShowCollectionCell *)[self.pictureCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [picCell.picView sd_setImageWithURL:[NSURL URLWithString:picUrlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            kLNFLog(@"---->>>>%zd---乱序", i);
        }];
    }
}

- (void)clearCellPicShow
{
    for (NSInteger i = 0; i < self.dataSourceHelper.items.count; i++) {
        LNFPictureLoadShowCollectionCell *picCell = (LNFPictureLoadShowCollectionCell *)[self.pictureCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        picCell.picView.image = nil;
    }
}

@end
