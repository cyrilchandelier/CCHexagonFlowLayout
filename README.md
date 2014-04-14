CCHexagonFlowLayout
===================

UICollectionView layout for both horizontal and vertical management of hexagonal cells

![ScreenShot](https://raw.github.com/cyrilchandelier/CCHexagonFlowLayout/master/Assets/CCHexagonFlowLayout.gif)

##Screenshots

![ScreenShot](https://raw.github.com/cyrilchandelier/CCHexagonFlowLayout/master/Assets/vertical.png)
 - 
![ScreenShot](https://raw.github.com/cyrilchandelier/CCHexagonFlowLayout/master/Assets/horizontal.png)

##Installation

There are two ways to use the library in your project:

1) Manually add the library files to your project

- CCHexagonFlowLayout.h
- CCHexagonFlowLayout.m

2) Using CocoaPods

```Ruby
pod 'CCHexagonFlowLayout'
```

##Usage

Begin with the creation of an instance of the CCHexagonFlowLayout

```
// Build layout
CCHexagonFlowLayout *layout = [[CCHexagonFlowLayout alloc] init];
layout.delegate = self;
```

Choose an orientation
```
layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
// OR
layout.scrollDirection = UICollectionViewScrollDirectionVertical;
```

Configure these variables according to your own hexagonal cells:
```
// Should be negative in order to reduce the space between hexagon and obtain the hive effect
layout.minimumInteritemSpacing = -30.0f;

// You must find the correct value to obtain the desired effect
layout.minimumLineSpacing = 10.0f;

// Your cell size as a square
layout.itemSize = CGSizeMake(230, 200);

// The gap is a positive float that will be use to obtain the hive effect
layout.gap = 76.0f;
```

Default flow layout options can be used for header/footer supplementary views and sections
```
layout.headerReferenceSize = CGSizeMake(320, 50);
layout.footerReferenceSize = CGSizeMake(320, 50);
layout.sectionInset = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
```

##Tests

- Works fine with iOS7 on iPhone 3.5" and 4" and iPad
- Not tested on iOS6

##Contribute

The component has been developed for a single project, feel free to contribute to improve it.
