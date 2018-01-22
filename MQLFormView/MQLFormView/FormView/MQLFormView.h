//
//  MQLFormView.h
//  MQLFormView
//
//  Created by GT-iOS on 2018/1/22.
//  Copyright © 2018年 GT-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MQL_LineDirection) {
    MQL_LineDirectionVertical,
    MQL_LineDirectionHorizon
};
@class MQLFormView;
@protocol MQLFormViewDataSource <NSObject>
@required;
//单元格数量
- (NSInteger)numberOfCellsInFormView:(MQLFormView *)formView;
//单元格内容文字
- (NSString *)formView:(MQLFormView *)formView titleForCellAtIndex:(NSUInteger)index;
//单元格尺寸, 注意所有单元格尺寸需要符合单元格总数和行列数
- (CGSize)formView:(MQLFormView *)formView sizeForCellAtIndex:(NSUInteger )index;
@optional;
//单元格背景颜色
- (UIColor *)formView:(MQLFormView *)formView backgroundColorForCellAtIndex:(NSUInteger )index;
//单元格字体颜色
- (UIColor *)formView:(MQLFormView *)formView titleColorForCellAtIndex:(NSUInteger )index;
@end

@interface MQLFormView : UIView
@property (nonatomic, weak) id<MQLFormViewDataSource> dataSource;
- (void)formViewReload;
@end
