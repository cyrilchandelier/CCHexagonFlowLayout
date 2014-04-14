//
//  RootCell.m
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/8/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "RootCell.h"



@interface RootCell ()

// Outlets
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end



@implementation RootCell

#pragma mark - Utils
static UINib *cellNib;
+ (UINib*)cellNib
{
	if (cellNib)
		return cellNib;
	
	// Build cell nib
	cellNib = [UINib nibWithNibName:RootCell_XIB
                             bundle:nil];
	
	return cellNib;
}

#pragma mark - Configuration
- (void)configureWithInt:(NSInteger)anInteger
{
    _titleLabel.text = [NSString stringWithFormat:@"%d", anInteger];
}

@end
