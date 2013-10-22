//
//  PSCollectionLayout.m
//  testIOS7
//
//  Created by Tomasz Kwolek on 07.10.2013.
//  Copyright (c) 2013 Tomasz Kwolek 2013 www.pastez.com. All rights reserved.
//

#import "PSCollectionLayout.h"

#pragma mark - settings

@implementation PSCollectionLayoutSettings

- (id)init
{
    self = [super init];
    if (self) {
        self.layoutInsets       = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        self.bigItemRightMagin  = 10.0f;
        self.bigItemSize        = CGSizeMake(100.0f, 123.0f);
        self.smallItemSize      = CGSizeMake(61.0f, 61.0f);
    }
    return self;
}

@end

#pragma mark - layout

@interface PSCollectionLayout()

@property (strong,nonatomic) NSArray *itemAttributes;
@property (readonly,nonatomic) CGFloat layoutHeight;

@end

@implementation PSCollectionLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.settings = [[PSCollectionLayoutSettings alloc] init];
    }
    return self;
}

- (id)initWithCollectionLayoutSettings:(PSCollectionLayoutSettings *)settings
{
    self = [super init];
    if (self) {
        self.settings = settings;
    }
    return self;
}

- (void)setSettings:(PSCollectionLayoutSettings *)settings
{
    _settings = settings;
    [self invalidateLayout];
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSMutableArray *itemAttributes = [NSMutableArray array];
    
    CGFloat layoutWidth     = CGRectGetWidth(self.collectionView.frame);
    CGFloat layoutHeight    = CGRectGetHeight(self.collectionView.frame);
    
    // calculate basic
    CGFloat startX  = _settings.layoutInsets.left;
    CGFloat startY  = _settings.layoutInsets.top;
    CGFloat endX    = layoutWidth - _settings.layoutInsets.right;
    
    // calculate horizontal layout
    CGFloat widthForItems           = layoutWidth - _settings.bigItemSize.width - _settings.bigItemRightMagin - _settings.layoutInsets.left - _settings.layoutInsets.right;
    CGFloat smallItemsRowCnt        = floorf(widthForItems / _settings.smallItemSize.width);
    CGFloat smallItemsLeftMargin    = floorf((widthForItems - smallItemsRowCnt * _settings.smallItemSize.width ) / smallItemsRowCnt);
    
    //calculate vertical layout
    CGFloat smallItemsColCnt        = floorf(_settings.bigItemSize.height / _settings.smallItemSize.height);
    CGFloat smallItemBottomMargin   = floorf((_settings.bigItemSize.height - smallItemsColCnt * _settings.smallItemSize.height) / (smallItemsColCnt - 1));
    
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    NSInteger itemsCount;
    
    _layoutHeight = 0;
    
    CGFloat dx, dy, sectionDy;
    for (int section = 0; section < sectionsCount; section++)
    {
        
        NSMutableArray *sectionAtributes = [NSMutableArray array];
        
        itemsCount = [self.collectionView numberOfItemsInSection:section];
        dx          = startX;
        dy          = startY + _layoutHeight;
        sectionDy   = dy;
        
        for (int item = 0; item < itemsCount; item++)
        {
            
            //if (item > 0 && fmodf(item, smallItemsColCnt+1) == 0) {
            if ( dx + _settings.smallItemSize.width > endX)
            {
                dx = startX + _settings.bigItemSize.width + _settings.bigItemRightMagin;
                dy += smallItemBottomMargin + _settings.smallItemSize.height;
                if (dy >= sectionDy + _settings.bigItemSize.height + smallItemBottomMargin) {
                    dx = startX;
                }
            }
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            if (item == 0)
            {
                // big item
                attributes.frame = CGRectMake(dx, dy, _settings.bigItemSize.width, _settings.bigItemSize.height);
                dx += _settings.bigItemSize.width + _settings.bigItemRightMagin;
            }
            else if (item > 0)
            {
                // items in row with big one
                attributes.frame = CGRectMake(dx, dy, _settings.smallItemSize.width, _settings.smallItemSize.height);
                dx += CGRectGetWidth(attributes.frame) + smallItemsLeftMargin;
            }
            
            [sectionAtributes addObject:attributes];
            
            if (_layoutHeight < CGRectGetMaxY(attributes.frame)) {
                _layoutHeight = CGRectGetMaxY(attributes.frame);
            }
        }
        [itemAttributes addObject:sectionAtributes];
    }
    
    self.itemAttributes = itemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    UICollectionViewLayoutAttributes *atributes = self.itemAttributes[path.row][path.section];
	return atributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	NSMutableArray *attributes = [NSMutableArray array];
    
	for (NSArray *section in _itemAttributes) {
        for (UICollectionViewLayoutAttributes *attribute in section) {
            if (CGRectIntersectsRect(rect, attribute.frame)) {
                [attributes addObject:attribute];
            }
        }
    }
	return [attributes copy];
}

- (CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake(CGRectGetWidth(self.collectionView.frame), _layoutHeight + _settings.layoutInsets.bottom);
    return size;
}

@end
