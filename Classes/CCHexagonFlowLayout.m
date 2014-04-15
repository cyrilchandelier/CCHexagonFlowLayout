//
//  CCHexagonFlowLayout.m
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/8/14.
//  Copyright (c) 2014 Cyril CHANDELIER. All rights reserved.
//

#import "CCHexagonFlowLayout.h"



#define SPARE_CELLS  10



@interface CCHexagonFlowLayout ()

// Counters
@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) NSInteger cellsPerLine;
@property (nonatomic, strong) NSArray   *cellCountPerSection;

@end



@implementation CCHexagonFlowLayout

#pragma mark - UICollectionViewLayout
- (void)prepareLayout
{
    [super prepareLayout];
    
    // Section count
    self.sectionCount = [self.collectionView numberOfSections];
    
    // Cell counts
    self.cellCount = 0;
    NSMutableArray *counts = [NSMutableArray array];
    for (NSInteger i = 0; i < _sectionCount; i++)
    {
        NSInteger cellCountInSection = [self.collectionView numberOfItemsInSection:i];
        
        // Update cell count
        self.cellCount += cellCountInSection;
        
        // Update section cell count
        [counts addObject:@(cellCountInSection)];
    }
    self.cellCountPerSection = counts;
    
    // Cells per line
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        _cellsPerLine = floor((CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.left - self.sectionInset.right) / (self.itemSize.width + self.minimumInteritemSpacing));
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGSize)collectionViewContentSize
{
    CGFloat width = 0;
    CGFloat height = 0;
    
    // Compute width and height according to scroll direction
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        // Compute width
        width += self.headerReferenceSize.width * self.sectionCount;
        width += (self.sectionInset.left + self.sectionInset.right) * self.sectionCount;
        for (NSInteger i = 0; i < _sectionCount; i++)
        {
            width += self.itemSize.width * [[_cellCountPerSection objectAtIndex:i] intValue];
            width += self.minimumInteritemSpacing * ([[_cellCountPerSection objectAtIndex:i] intValue] - 1);
        }
        width += self.footerReferenceSize.width * self.sectionCount;
        
        // Height is collection view height
        height = CGRectGetHeight(self.collectionView.bounds);
    }
    else
    {
        // Width is collection view width
        width = CGRectGetWidth(self.collectionView.bounds);
        
        // Compute height
        height += self.headerReferenceSize.height * self.sectionCount;
        height += (self.sectionInset.top + self.sectionInset.bottom) * self.sectionCount;
        for (NSInteger i = 0; i < _sectionCount; i++)
            height += [self cellsHeightForSection:i];
        height += self.footerReferenceSize.height * self.sectionCount;
    }
    
    // Build content size
    CGSize contentSize = {
        .width = width,
        .height = height,
    };
    
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];

    // Indexes
    NSInteger start;
    NSInteger end;
    
    // Compute start/end indexes according to scroll direction
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        //TODO: bug sections
        start = MAX((NSInteger)CGRectGetMinX(rect) / (self.itemSize.width + self.minimumInteritemSpacing) - SPARE_CELLS, 0);
        end = MIN((NSInteger)CGRectGetMaxX(rect) / (self.itemSize.width + self.minimumInteritemSpacing) + SPARE_CELLS, self.cellCount);
    }
    else
    {
        //TODO: verify these indexes
        start = MAX(ceil((NSInteger)CGRectGetMinY(rect) / (self.itemSize.height + self.minimumLineSpacing)) * _cellsPerLine - SPARE_CELLS, 0);
        end = MIN(ceil((NSInteger)CGRectGetMaxY(rect) / (self.itemSize.height + self.minimumLineSpacing)) * _cellsPerLine + SPARE_CELLS, self.cellCount);
    }
    
    // Find first index item and section
    NSInteger item = 0;
    NSInteger section = 0;
    for (NSInteger i = 0; i < start; i++)
    {
        // Manage sections and items
        if (item == ([[_cellCountPerSection objectAtIndex:section] intValue] - 1))
        {
            section++;
            item = 0;
        }
        else
        {
            item++;
        }
    }
    
    // Loop over attributes
    for (NSInteger i = start; i != end; ++i)
    {
        // Section header
        if (item == 0)
        {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            if (attributes)
                [allAttributes addObject:attributes];
        }
        
        // Footer
        if (item == [[_cellCountPerSection objectAtIndex:section] intValue] - 1)
        {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            if (attributes)
                [allAttributes addObject:attributes];
        }
        
        // Build index path
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        
        // Get attributes
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (attributes)
            [allAttributes addObject:attributes];
        
        // Manage sections and items
        if (item >= ([[_cellCountPerSection objectAtIndex:section] intValue] - 1))
        {
            section++;
            item = 0;
        }
        else
        {
            item++;
        }
    }
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get attributes
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    // Compute center
    CGFloat x = [self centerXForItemAtIndexPath:indexPath];
    CGFloat y = [self centerYForItemAtIndexPath:indexPath];
    
    // Update attributes
	attributes.center = (CGPoint) { x, y };
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    // Prevent empty header or footer
    if (([kind isEqualToString:UICollectionElementKindSectionHeader] && CGSizeEqualToSize(self.headerReferenceSize, CGSizeZero)) || ([kind isEqualToString:UICollectionElementKindSectionFooter] && CGSizeEqualToSize(self.footerReferenceSize, CGSizeZero)))
        return nil;
    
    // Get attributes
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    
    // Compute center
    CGFloat x = [self centerXForSupplementaryViewOfKind:kind section:indexPath.section];
    CGFloat y = [self centerYForSupplementaryViewOfKind:kind section:indexPath.section];
    
    // Update attributes
    attributes.center = (CGPoint) { x, y };
    
    return attributes;
}

#pragma mark - Utils
- (CGFloat)centerXForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat x = 0;
    
    // Compute y position according to scroll direction
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        // Section header
        x += self.headerReferenceSize.width * (indexPath.section + 1);
        
        // Section left inset
        x += self.sectionInset.left * (indexPath.section + 1);
        
        // Previous sections hexagons
        for (NSInteger i = 0; i < indexPath.section; i++)
        {
            // Cells pure width
            x += self.itemSize.width * [[_cellCountPerSection objectAtIndex:i] intValue];
            
            // Inter item spaces
            x += self.minimumInteritemSpacing * ([[_cellCountPerSection objectAtIndex:i] intValue] - 1);
        }
        
        // Current section hexagons pure width and inter item spaces
        x += self.itemSize.width * (indexPath.item + 1) - (self.itemSize.width / 2);
        x += self.minimumInteritemSpacing * indexPath.item;
        
        // Section right inset
        x += self.sectionInset.right * indexPath.section;
        
        // Section footer
        x += self.footerReferenceSize.width * indexPath.section;
    }
    else
    {
        NSInteger indexInLine = (indexPath.item % _cellsPerLine);
        
        x = self.itemSize.width * indexInLine + (self.itemSize.width / 2);
        x += self.minimumInteritemSpacing * indexInLine;
        x += self.sectionInset.left;
    }
    
    return x;
}

- (CGFloat)centerYForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat y = 0;
    
    // Compute y position according to scroll direction
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        y = self.itemSize.height / 2 + ((indexPath.item % 2 == 0) ? 0 : _gap);
    }
    else
    {
        // Section header
        y += self.headerReferenceSize.height * (indexPath.section + 1);
        
        // Section top inset
        y += self.sectionInset.top * (indexPath.section + 1);
        
        // Previous sections hexagons
        for (NSInteger i = 0; i < indexPath.section; i++)
            y += [self cellsHeightForSection:i];
        
        // Current line
        NSInteger currentLine = floor((float)indexPath.item / (float)_cellsPerLine);
        
        // Current section hexagons pure height and inter line spaces
        y += self.itemSize.height * currentLine + (self.itemSize.height / 2);
        y += self.minimumLineSpacing * currentLine;
        
        // Shift
        NSInteger indexInLine = (indexPath.item % _cellsPerLine);
        y += (indexInLine % 2 == 0) ? 0 : _gap;
        
        // Section bottom inset
        y += self.sectionInset.bottom * indexPath.section;
        
        // Section footer
        y += self.footerReferenceSize.height * indexPath.section;
    }
    
    return y;
}

- (CGFloat)centerXForSupplementaryViewOfKind:(NSString *)kind section:(NSInteger)section
{
    CGFloat x;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        // Header
        if ([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            x = [self centerXForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            
            // Fake first cell half width
            x -= self.itemSize.width / 2;
            
            // Section inset
            x -= self.sectionInset.left;
            
            // Header half
            x -= self.headerReferenceSize.width / 2;
        }
        // Footer
        else
        {
            x = [self centerXForItemAtIndexPath:[NSIndexPath indexPathForItem:([[_cellCountPerSection objectAtIndex:section] intValue] - 1) inSection:section]];
            
            // Fake last cell half width
            x += self.itemSize.width / 2;
            
            // Section inset
            x += self.sectionInset.right;
            
            // Footer half
            x += self.footerReferenceSize.width / 2;
        }
    }
    else
    {
        // Header
        if ([kind isEqualToString:UICollectionElementKindSectionHeader])
            x = self.headerReferenceSize.width / 2;
        else
            x = self.footerReferenceSize.width / 2;
    }
    
    return x;
}

- (CGFloat)centerYForSupplementaryViewOfKind:(NSString *)kind section:(NSInteger)section
{
    CGFloat y;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        // Header
        if ([kind isEqualToString:UICollectionElementKindSectionHeader])
            y = self.headerReferenceSize.height / 2;
        else
            y = self.footerReferenceSize.height / 2;
    }
    else
    {
        // Header
        if ([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            y = [self centerYForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            
            // First cell half size
            y -= self.itemSize.height / 2;
            
            // Section inset
            y -= self.sectionInset.top;
            
            // Header half
            y -= self.headerReferenceSize.height / 2;
        }
        // Footer
        else
        {
            y = [self centerYForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            
            // First cell half size
            y -= self.itemSize.height / 2;
            
            // Section height
            y += [self cellsHeightForSection:section];
            
            // Section inset
            y += self.sectionInset.bottom;
            
            // Header half
            y += self.headerReferenceSize.height / 2;
        }
    }
    
    return y;
}

- (CGFloat)cellsHeightForSection:(NSInteger)section
{
    CGFloat height = 0;
    
    // Compute height according to scroll direction
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        height = CGRectGetHeight(self.collectionView.bounds);
    }
    else
    {
        NSInteger cellsInSection = [[_cellCountPerSection objectAtIndex:section] intValue];
        NSInteger linesInSection = ceil(cellsInSection / (float)_cellsPerLine);
        
        if (cellsInSection == 0)
        {
            return 0;
        }
        else if (cellsInSection == 1)
        {
            return self.itemSize.height;
        }
        else if (cellsInSection % _cellsPerLine == 1)
        {
            // All except last line
            height += (linesInSection - 1) * self.itemSize.height;
            
            // Last line
            height += self.itemSize.height;
            
            // Space between lines
            height += self.minimumLineSpacing * (linesInSection - 1);
        }
        else
        {
            // Item height
            height += linesInSection * self.itemSize.height;
            
            // Interline space
            height += (linesInSection - 1) * self.minimumLineSpacing;
            
            // Gap for final line
            height += _gap;
        }
    }
    
    return height;
}

@end
