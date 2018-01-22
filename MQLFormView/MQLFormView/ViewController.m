//
//  ViewController.m
//  MQLFormView
//
//  Created by GT-iOS on 2018/1/22.
//  Copyright © 2018年 GT-iOS. All rights reserved.
//

#import "ViewController.h"
#import "MQLFormView.h"

@interface ViewController ()<MQLFormViewDataSource>
@property (nonatomic, strong) MQLFormView *formView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formView = [[MQLFormView alloc]initWithFrame:CGRectMake(15, 100, self.view.bounds.size.width - 30, 80)];
    self.formView.dataSource = self;
    [self.view addSubview:self.formView];
}

- (NSInteger)numberOfCellsInFormView:(MQLFormView *)formView {
    return 8;
}

- (CGSize)formView:(MQLFormView *)formView sizeForCellAtIndex:(NSUInteger)index {
    return CGSizeMake(formView.bounds.size.width / 4.0, 40);
}

- (NSString *)formView:(MQLFormView *)formView titleForCellAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%ld", index];
}
- (UIColor *)formView:(MQLFormView *)formView titleColorForCellAtIndex:(NSUInteger)index {
    if (index < 4) {
        return [UIColor blueColor];
    }
    return [UIColor orangeColor];
}

- (UIColor *)formView:(MQLFormView *)formView backgroundColorForCellAtIndex:(NSUInteger)index {
    if (index < 4) {
        return [UIColor orangeColor];
    }
    return [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
