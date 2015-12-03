//
//  DSScanView.m
//  QRCodeScaningDemo
//
//  Created by LS on 12/2/15.
//  Copyright © 2015 LS. All rights reserved.
//

#import "DSScanView.h"

@interface DSScanView ()
{
    CGRect _lineStartRect;
    CGRect _lineEndRect;
}

@property (nonatomic, strong) UIImageView *lineImageView;

@end

@implementation DSScanView

#pragma mark - Initial

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _borderColor = [UIColor whiteColor];
        _borderWidth = 0.5;
        
        [self addSubview:self.lineImageView];
        [self setupAcrossView];
        [self startScanLineAnimation];
    }
    
    return self;
}

#pragma mark - Setup Across

- (void)startScanLineAnimation
{
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView animateWithDuration:1.5 animations:^{
        self.lineImageView.frame = self->_lineEndRect;
    } completion:^(BOOL finished) {
        self.lineImageView.frame = self->_lineStartRect;
        [self startScanLineAnimation];
    }];
}

- (void)setupAcrossView
{
    for (int i =  1; i < 5; i++)
    {
        [self configurateImageViewPostionWithTag:i];
    }
}

- (void)configurateImageViewPostionWithTag:(NSInteger)tag
{
    CGFloat x = 0.0,y = 0.0,width = 0.0,height = 0.0;
    NSString *imageName = [NSString stringWithFormat:@"QRCodeScan.bundle/ScanQR%zd",tag];
    UIImage *image= [UIImage imageNamed:imageName];
    
    width = image.size.width;
    height = image.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    if(tag == 1 || tag == 3)
    {
        x = 0.0;
        y = tag == 1? 0.0 : CGRectGetHeight(self.bounds)-height;
    }
    else if(tag == 2 || tag == 4)
    {
        x = CGRectGetWidth(self.bounds) - width;
        y = tag == 2? 0 : CGRectGetHeight(self.bounds)-height;
    }
    
    imageView.frame = CGRectMake(x, y, width, height);
    [self addSubview:imageView];
}

#pragma mark - DrawLine

- (void)drawRect:(CGRect)rect
{

    UIImage *image = [UIImage imageNamed:@"QRCodeScan.bundle/ScanQR1"];
    CGFloat length = CGRectGetWidth(self.bounds);
    CGFloat start = image.size.width;
    CGFloat end = image.size.height;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start, 0.0);
    CGPathAddLineToPoint(path, NULL, length-start, 0.0);
    
    CGPathMoveToPoint(path, NULL, length, end);
    CGPathAddLineToPoint(path, NULL, length, length-end);
    
    CGPathMoveToPoint(path, NULL, start, length);
    CGPathAddLineToPoint(path, NULL, length-start, length);
    
    CGPathMoveToPoint(path, NULL, 0.0, start);
    CGPathAddLineToPoint(path, NULL, 0.0, length-end);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextStrokePath(context);
    
    CGPathRelease(path);
}

#pragma mark - Setter && Getter

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (UIImageView *)lineImageView
{
    if(!_lineImageView)
    {
        UIImage *image = [UIImage imageNamed:@"QRCodeScan.bundle/QRCodeScanLine"];
        CGFloat x = (CGRectGetWidth(self.bounds) - image.size.width) * 0.5;
        _lineImageView = [[UIImageView alloc] initWithImage:image];
        _lineStartRect = CGRectMake(x, 0.0, image.size.width, image.size.height);
        _lineEndRect = CGRectMake(x, CGRectGetHeight(self.bounds)-image.size.height, image.size.width, image.size.height);
        _lineImageView.frame = _lineStartRect;
    }
    
    return _lineImageView;
}

@end
