//
//  CCHexCell.m
//  CCHexagonFlowLayout
//
//  Created by Yamazaki Mitsuyoshi on 1/27/15.
//  Copyright (c) 2015 Cyril Chandelier. All rights reserved.
//

#import "CCHexCell.h"

@interface CCHexCell()

@property (nonatomic, strong) CAShapeLayer *borderLayer;

- (void)initialize;
- (void)setLayerMask;

@end

@implementation CCHexCell

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initialize];
}

- (void)initialize {
	
	self.borderLayer = [[CAShapeLayer alloc] init];
	[self.layer addSublayer:self.borderLayer];
}

#pragma mark - Accessor
- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setLayerMask];
}

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	[self setLayerMask];
}

- (void)setLayerMask {
	
	UIBezierPath *clippingPath = [[UIBezierPath alloc] init];
	
	CGFloat width = self.bounds.size.width;
	CGFloat height = self.bounds.size.height;
	CGFloat radius = width / 2.0;
	
	[clippingPath moveToPoint:CGPointMake(radius * 0.5, 0.0)];
	[clippingPath addLineToPoint:CGPointMake(radius * 1.5, 0.0)];
	[clippingPath addLineToPoint:CGPointMake(width, height * 0.5)];
	[clippingPath addLineToPoint:CGPointMake(radius * 1.5, height)];
	[clippingPath addLineToPoint:CGPointMake(radius * 0.5, height)];
	[clippingPath addLineToPoint:CGPointMake(0.0, height * 0.5)];
	[clippingPath closePath];
	
	
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	
	maskLayer.path = clippingPath.CGPath;
	maskLayer.lineJoin = kCALineJoinRound;
	
	self.layer.mask = maskLayer;
	
	self.borderLayer.path = clippingPath.CGPath;
	self.borderLayer.fillColor = [UIColor clearColor].CGColor;
	self.borderLayer.lineJoin = kCALineJoinMiter;
}

- (void)setBorderWithColor:(UIColor *)color width:(CGFloat)width {
	
	self.borderLayer.strokeColor = color.CGColor;
	self.borderLayer.lineWidth = width;
}

@end
