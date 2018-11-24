//
//  LNFAssetRequestImageHelpModel.h
//  iOS_Learning
//
//  Created by MrLiu on 2018/9/3.
//  Copyright © 2018年 interstellar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LNFRequestImageAssetType) {
    AssetUnknown = 0,
    AssetImage,
    AssetVideo,
    AssetAudio
};
@interface LNFAssetRequestImageHelpModel : NSObject

@property (nonatomic, strong) UIImage *requstImage;
@property (nonatomic, copy) NSString *imageIndex;
@property (nonatomic, assign) LNFRequestImageAssetType assetType;
@property (nonatomic, copy) NSString *localIdentifier;

@end
