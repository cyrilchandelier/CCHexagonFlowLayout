//
//  FooterView.h
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/12/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#define FooterView_ID                   @"FooterViewID"
#define FooterView_XIB                  @"FooterView"
#define FooterView_SIZE(direction)      (direction == UICollectionViewScrollDirectionHorizontal) ? CGSizeMake(50, 200) : CGSizeMake(1024, 50)



@interface FooterView : UICollectionReusableView

// View nib
+ (UINib *)viewNib;

@end
