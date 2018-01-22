//
//  MQLFormCell.m
//  MQLFormView
//
//  Created by GT-iOS on 2018/1/22.
//  Copyright © 2018年 GT-iOS. All rights reserved.
//

#import "MQLFormCell.h"

@implementation MQLFormCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_contentLab) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _contentLab = ({
        UILabel *label = [UILabel new];
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:13];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [self.contentView addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [label.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        [label.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [label.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        [label.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
        label;
    });
}
@end
