//
//  HeaderView.h
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/12/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#define HeaderView_ID                   @"HeaderViewID"
#define HeaderView_XIB                  @"HeaderView"
#define HeaderView_SIZE(direction)      (direction == UICollectionViewScrollDirectionHorizontal) ? CGSizeMake(50, 50) : CGSizeMake(320, 50)



@interface HeaderView : UICollectionReusableView

// View nib
+ (UINib *)viewNib;

@end
