//
//  LNFCollectionViewDelegateHelper.m
//  iOS_Learning
//
//  Created by mrliu on 2018/10/24.
//  Copyright © 2018 interstellar. All rights reserved.
//

#import "LNFCollectionViewDelegateHelper.h"

@implementation LNFCollectionViewDelegateHelper

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(indexPath);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    kLNFLog(@"----1>>>>%@", @"scrollViewDidScroll");
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    kLNFLog(@"----2>>>>%@", @"scrollViewWillBeginDragging");
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    kLNFLog(@"----3>>>>%@", @"scrollViewWillEndDragging");
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    kLNFLog(@"----4>>>>%@", @"scrollViewDidEndDragging");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    kLNFLog(@"----5>>>>%@", @"scrollViewWillBeginDecelerating");
}// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    kLNFLog(@"----6>>>>%@", @"scrollViewDidEndDecelerating");
}// called when scroll view grinds to a halt

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    kLNFLog(@"----7>>>>%@", @"scrollViewDidEndScrollingAnimation");
}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}// return a yes if you want to scroll to the top. if not defined, assumes YES
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    kLNFLog(@"----8>>>>%@", @"scrollViewDidScrollToTop");
}// called when scrolling animation finished. may be called immediately if already at top

@end
