//
//  FirstViewController.m
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/15/14.
//  Copyright (c) 2014 Cyril Chandelier. All rights reserved.
//

#import "FirstViewController.h"
#import "RootCell.h"
#import "HeaderView.h"
#import "FooterView.h"



@interface FirstViewController ()

// Collection view
@property (nonatomic, strong) UICollectionView *collectionView;

@end



@implementation FirstViewController


#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build layout
    CCHexagonFlowLayout *layout = [[CCHexagonFlowLayout alloc] init];
    layout.delegate = self;
    // layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = -30.0f;
    layout.minimumLineSpacing = 10.0f;
    layout.sectionInset = UIEdgeInsetsMake(20.0f, 15.0f, 20.0f, 15.0f);
    layout.itemSize = RootCell_SIZE;
    layout.headerReferenceSize = HeaderView_SIZE(layout.scrollDirection);
    layout.footerReferenceSize = FooterView_SIZE(layout.scrollDirection);
    layout.gap = 76.0f;
    
    // Build collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell and views
    [_collectionView registerNib:[RootCell cellNib] forCellWithReuseIdentifier:RootCell_ID];
    [_collectionView registerNib:[HeaderView viewNib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderView_ID];
    [_collectionView registerNib:[FooterView viewNib] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterView_ID];
    
    // Add to view
    [self.view addSubview:_collectionView];
    
    // Reload data
    [_collectionView reloadData];
}

#pragma mark - UICollectionDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 50;
            
        case 1:
            return 13;
            
        case 2:
            return 1;
            
        default:
            return 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RootCell_ID forIndexPath:indexPath];
    [cell configureWithInt:indexPath.item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    // Section header
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
        return [_collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                   withReuseIdentifier:HeaderView_ID
                                                          forIndexPath:indexPath];
    
    // Section footer
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
        return [_collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                   withReuseIdentifier:FooterView_ID
                                                          forIndexPath:indexPath];
    
    return nil;
}

@end
