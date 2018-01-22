//
//  MQLFormView.m
//  MQLFormView
//
//  Created by GT-iOS on 2018/1/22.
//  Copyright © 2018年 GT-iOS. All rights reserved.
//

#import "MQLFormView.h"
#import "MQLFormCell.h"
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

static NSString *const MQL_formCellId = @"MQL_formCell";

@interface MQLFormView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *formView;
@property (nonatomic, strong) UIBezierPath *formBezierPath;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@end
@implementation MQLFormView

#pragma mark - UICollectionViewDataSource

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.formView];
        [self.layer addSublayer:self.lineLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.formView.frame = self.bounds;
    self.lineLayer.frame = self.bounds;
    self.lineLayer.path = self.formBezierPath.CGPath;
}
- (void)formViewReload {
    self.formBezierPath = nil;
    [self.formView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfCellsInFormView:self];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MQLFormCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MQL_formCellId forIndexPath:indexPath];
    cell.contentLab.text = [self.dataSource formView:self titleForCellAtIndex:indexPath.row];
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(formView:backgroundColorForCellAtIndex:)]) {
        cell.contentView.backgroundColor = [self.dataSource formView:self backgroundColorForCellAtIndex:indexPath.row] ?: self.backgroundColor;
    } else {
        cell.contentView.backgroundColor = self.backgroundColor;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(formView:titleColorForCellAtIndex:)]) {
        cell.contentLab.textColor = [self.dataSource formView:self titleColorForCellAtIndex:indexPath.row] ?: [UIColor blackColor];
    } else {
        cell.contentLab.textColor = [UIColor blackColor];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource formView:self sizeForCellAtIndex:indexPath.row];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [self convertRect:cell.contentView.frame fromView:cell.contentView.superview];
    [self mql_drawRectWithRect:rect];
}

#pragma mark - getters
- (UICollectionView *)formView {
    if (!_formView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.000f;
        layout.minimumInteritemSpacing = 0.000f;
        _formView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_formView registerClass:[MQLFormCell class] forCellWithReuseIdentifier:MQL_formCellId];
        _formView.showsVerticalScrollIndicator = NO;
        _formView.showsHorizontalScrollIndicator = NO;
        _formView.backgroundColor = self.backgroundColor;
        _formView.delegate = self;
        _formView.dataSource = self;
    }
    return _formView;
}

- (UIBezierPath *)formBezierPath {
    if (!_formBezierPath) {
        _formBezierPath = [[UIBezierPath alloc]init];
        _formBezierPath.lineWidth = 0.5;
    }
    return _formBezierPath;
}

- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = [UIColor redColor].CGColor;
        _lineLayer.lineWidth = 0.5;
    }
    return _lineLayer;
}

#pragma mark - 绘制线框
- (void)mql_drawRectWithRect:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = (1.0) * rect.size.width;
    CGFloat h = (1.0) * rect.size.height;
    
    if (((int)(y * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        y += SINGLE_LINE_ADJUST_OFFSET;
    }
    if (((int)(x * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        x += SINGLE_LINE_ADJUST_OFFSET;
    }
    if (x == 0 && y == 0) {
        [self mql_drawLineWithFrame:(CGRect){x, y, w, h}lineType:MQL_LineDirectionVertical color:[UIColor redColor] lineWidth:0.25];
        [self mql_drawLineWithFrame:(CGRect){x, y, w, h} lineType:MQL_LineDirectionHorizon color:[UIColor redColor] lineWidth:0.25];
    } else if (y == 0) {
        [self mql_drawLineWithFrame:(CGRect){x, y, w, h}lineType:MQL_LineDirectionVertical color:[UIColor redColor] lineWidth:0.25];
        if (fabsf((float)(x + w - self.bounds.size.width)) < 1) {
            [self mql_drawLineWithFrame:(CGRect){x + w, y, w, h}lineType:MQL_LineDirectionVertical color:[UIColor redColor] lineWidth:0.25];
        }
    } else if (x == 0) {
        [self mql_drawLineWithFrame:(CGRect){x, y, w, h} lineType:MQL_LineDirectionHorizon color:[UIColor redColor] lineWidth:0.25];
        if (fabsf((float)(y + h - self.bounds.size.height)) < 1) {
            [self mql_drawLineWithFrame:(CGRect){x, y + h, w, h}lineType:MQL_LineDirectionHorizon color:[UIColor redColor] lineWidth:0.25];
        }
    }
}
- (void)mql_drawLineWithFrame:(CGRect)frame lineType:(MQL_LineDirection)lineDirection color:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    [self.formBezierPath moveToPoint:frame.origin];
    [self.formBezierPath addLineToPoint: lineDirection == MQL_LineDirectionHorizon ? CGPointMake(self.bounds.size.width, frame.origin.y) : CGPointMake(frame.origin.x, self.bounds.size.height)];
    if (self.translatesAutoresizingMaskIntoConstraints == YES) {//使用frame布局时需要这句
        [self setNeedsLayout];
    }
}


@end
