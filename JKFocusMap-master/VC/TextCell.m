//
//  TextCell.m
//  JKFocusMap-master
//
//  Created by Jack Wang on 2018/4/13.
//  Copyright © 2018年 jack_wang. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell

- (void)drawRect:(CGRect)rect{
    
    
    //创建路径并获取句柄
    
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    //指定矩形
    
    
    CGRect rectangle = CGRectMake(0.0f, 0.0f,60.0f,
                                  44.0f);
    
    
    //将矩形添加到路径中
    
    
    CGPathAddRect(path,NULL,
                  rectangle);
    
    
    //获取上下文
    
    
    CGContextRef currentContext =
    UIGraphicsGetCurrentContext();
    
    
    //将路径添加到上下文
    
    
    CGContextAddPath(currentContext, path);
    
    
    //设置矩形填充色
    
    
    [[UIColor colorWithRed:0.20f green:0.60f blue:0.80f alpha:1.0f]
     setFill];
    
    
    //矩形边框颜色
    
    
    [[UIColor brownColor] setStroke];
    
    
    //边框宽度
    
    
    CGContextSetLineWidth(currentContext,5.0f);
    
    
    //绘制
    
    
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    
    CGPathRelease(path);
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
