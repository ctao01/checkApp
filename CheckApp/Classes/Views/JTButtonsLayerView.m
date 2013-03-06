//
//  JTButtonsLayerView.m
//  CheckApp
//
//  Created by Joy Tao on 3/6/13.
//  Copyright (c) 2013 Joy Tao. All rights reserved.
//

#import "JTButtonsLayerView.h"
#import "JTItemGroupedCell.h"

@implementation JTButtonsLayerView
@synthesize cell;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    JTItemGroupedCell * groupedCell = (JTItemGroupedCell*)self.cell;
    
    [groupedCell drawSeperateLine:rect];
    [groupedCell setupExpiredButton:rect];
    [groupedCell setupButtons:rect];
//    [[UIColor lightGrayColor] setStroke];
//
//    
//    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
//    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, startPoint.y);
//    UIBezierPath * path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    [path addLineToPoint:endPoint];
//    [path stroke];
//    [path setLineWidth:2.0f];
//
//    
//    UIBezierPath * firstPath = [UIBezierPath bezierPath];
//    [firstPath moveToPoint:CGPointMake(startPoint.x + rect.size.width / 3, rect.origin.y)];
//    [firstPath addLineToPoint:CGPointMake(startPoint.x + rect.size.width / 3, rect.origin.y + rect.size.height)];
//    [firstPath stroke];
//    [firstPath setLineWidth:2.0f];
//
//    UIBezierPath * secondPath = [UIBezierPath bezierPath];
//    [secondPath moveToPoint:CGPointMake(startPoint.x + rect.size.width * 2 / 3, rect.origin.y)];
//    [secondPath addLineToPoint:CGPointMake(startPoint.x + rect.size.width * 2 / 3, rect.origin.y + rect.size.height)];
//    [secondPath stroke];
//    [secondPath setLineWidth:2.0f];

}

@end
