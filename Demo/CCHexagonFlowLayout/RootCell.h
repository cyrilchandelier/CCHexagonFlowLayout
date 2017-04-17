//
//  RootCell.h
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/8/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#define RootCell_ID     @"RootCellID"
#define RootCell_XIB    @"RootCell"
#define RootCell_SIZE   CGSizeMake(160, 145)

#import "CCHexCell.h"

@interface RootCell : CCHexCell

// Cell nib
+ (UINib *)cellNib;

// Configuration
- (void)configureWithInt:(NSInteger)anInteger;

@end
