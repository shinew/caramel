//
//  JBLineChartFooterView.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/8/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBLineChartFooterView : UIView

@property (nonatomic, strong) UIColor *footerSeparatorColor; // footer separator (default = white)
@property (nonatomic, assign) NSInteger sectionCount; // # of notches (default = 2 on each edge)
@property (nonatomic, readonly) UILabel *leftLabel;
@property (nonatomic, readonly) UILabel *rightLabel;
@property (nonatomic, readonly) UILabel *middleLeftLabel;
@property (nonatomic, readonly) UILabel *middleRightLabel;
@property (nonatomic, readonly) UILabel *centerLabel;

@end
