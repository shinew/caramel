//
//  JBLineChartFooterView.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/8/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBLineChartFooterView.h"

// Numerics
CGFloat const kJBLineChartFooterViewSeparatorWidth = 0.5f;
CGFloat const kJBLineChartFooterViewSeparatorHeight = 3.0f;
CGFloat const kJBLineChartFooterViewSeparatorSectionPadding = 1.0f;

// Colors
static UIColor *kJBLineChartFooterViewDefaultSeparatorColor = nil;

@interface JBLineChartFooterView ()

@property (nonatomic, strong) UIView *topSeparatorView;

@end

@implementation JBLineChartFooterView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [JBLineChartFooterView class])
	{
		kJBLineChartFooterViewDefaultSeparatorColor = [UIColor blackColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _footerSeparatorColor = kJBLineChartFooterViewDefaultSeparatorColor;
        
        _topSeparatorView = [[UIView alloc] init];
        _topSeparatorView.backgroundColor = _footerSeparatorColor;
        [self addSubview:_topSeparatorView];
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.adjustsFontSizeToFitWidth = YES;
        _leftLabel.font = [UIFont fontWithName:@"Univers-Light-Normal" size:10.0];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.text = @"6:00 am";
        
        [self addSubview:_leftLabel];
        
        _middleLeftLabel = [[UILabel alloc] init];
        _middleLeftLabel.adjustsFontSizeToFitWidth = YES;
        _middleLeftLabel.font = [UIFont fontWithName:@"Univers-Light-Normal" size:10.0];
        _middleLeftLabel.textAlignment = NSTextAlignmentLeft;
        _middleLeftLabel.textColor = [UIColor blackColor];
        _middleLeftLabel.backgroundColor = [UIColor clearColor];
        _middleLeftLabel.text = @"10:30 am";
        [self addSubview:_middleLeftLabel];
        
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.adjustsFontSizeToFitWidth = YES;
        _centerLabel.font = [UIFont fontWithName:@"Univers-Light-Normal" size:10.0];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.textColor = [UIColor blackColor];
        _centerLabel.backgroundColor = [UIColor clearColor];
        _centerLabel.text = @"3:00 pm";
        [self addSubview:_centerLabel];
        
        _middleRightLabel = [[UILabel alloc] init];
        _middleRightLabel.adjustsFontSizeToFitWidth = YES;
        _middleRightLabel.font = [UIFont fontWithName:@"Univers-Light-Normal" size:10.0];
        _middleRightLabel.textAlignment = NSTextAlignmentRight;
        _middleRightLabel.textColor = [UIColor blackColor];
        _middleRightLabel.backgroundColor = [UIColor clearColor];
        _middleRightLabel.text = @"7:30 pm";
        [self addSubview:_middleRightLabel];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.adjustsFontSizeToFitWidth = YES;
        _rightLabel.font = [UIFont fontWithName:@"Univers-Light-Normal" size:10.0];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.text = @"12:00 am";
        [self addSubview:_rightLabel];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.footerSeparatorColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetShouldAntialias(context, YES);

    CGFloat xOffset = 0;
    CGFloat yOffset = kJBLineChartFooterViewSeparatorWidth;
    CGFloat stepLength = ceil((self.bounds.size.width) / (self.sectionCount - 1));
    
    for (int i=0; i<self.sectionCount; i++)
    {
        CGContextSaveGState(context);
        {
            CGContextMoveToPoint(context, xOffset + (kJBLineChartFooterViewSeparatorWidth * 0.5), yOffset);
            CGContextAddLineToPoint(context, xOffset + (kJBLineChartFooterViewSeparatorWidth * 0.5), yOffset + kJBLineChartFooterViewSeparatorHeight);
            CGContextStrokePath(context);
            xOffset += stepLength;
        }
        CGContextRestoreGState(context);
    }
    
    if (self.sectionCount > 1)
    {
        CGContextSaveGState(context);
        {
            CGContextMoveToPoint(context, self.bounds.size.width - (kJBLineChartFooterViewSeparatorWidth * 0.5), yOffset);
            CGContextAddLineToPoint(context, self.bounds.size.width - (kJBLineChartFooterViewSeparatorWidth * 0.5), yOffset + kJBLineChartFooterViewSeparatorHeight);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _topSeparatorView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, kJBLineChartFooterViewSeparatorWidth);
    
    CGFloat xOffset = 0;
    CGFloat yOffset = kJBLineChartFooterViewSeparatorSectionPadding;
    CGFloat width = ceil(self.bounds.size.width * 0.2);
    
    self.leftLabel.frame = CGRectMake(xOffset, yOffset, width, self.bounds.size.height);
    self.middleLeftLabel.frame = CGRectMake(CGRectGetMaxX(self.leftLabel.frame), yOffset, width, self.bounds.size.height);
    self.centerLabel.frame = CGRectMake(CGRectGetMaxX(self.middleLeftLabel.frame), yOffset, width, self.bounds.size.height);
    self.middleRightLabel.frame = CGRectMake(CGRectGetMaxX(self.centerLabel.frame), yOffset, width, self.bounds.size.height);
    self.rightLabel.frame = CGRectMake(CGRectGetMaxX(self.middleRightLabel.frame), yOffset, width, self.bounds.size.height);
}

#pragma mark - Setters

- (void)setSectionCount:(NSInteger)sectionCount
{
    _sectionCount = sectionCount;
    [self setNeedsDisplay];
}

- (void)setFooterSeparatorColor:(UIColor *)footerSeparatorColor
{
    _footerSeparatorColor = footerSeparatorColor;
    _topSeparatorView.backgroundColor = _footerSeparatorColor;
    [self setNeedsDisplay];
}

@end
