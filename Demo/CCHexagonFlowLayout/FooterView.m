//
//  FooterView.m
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/12/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "FooterView.h"



@implementation FooterView

#pragma mark - Utils
static UINib *viewNib;
+ (UINib *)viewNib
{
	if (viewNib)
		return viewNib;
	
	// Build cell nib
	viewNib = [UINib nibWithNibName:FooterView_XIB
                             bundle:nil];
	
	return viewNib;
}

@end
