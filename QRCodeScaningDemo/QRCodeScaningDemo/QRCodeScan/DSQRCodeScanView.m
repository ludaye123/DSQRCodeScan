//
//  DSQRCodeScanView.m
//  QRCodeScaningDemo
//
//  Created by LS on 12/2/15.
//  Copyright © 2015 LS. All rights reserved.
//

#import "DSQRCodeScanView.h"
#import "DSScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface DSQRCodeScanView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) DSScanView *scanAreaView;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@end

static CGFloat const edge = 50.0;

@implementation DSQRCodeScanView

+ (instancetype)scanViewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addSubview:self.scanAreaView];
        [self setupCaptureVideoPreviewLayer];
        [self startScan];
        [self configurateOverView];
    }
    
    return self;
}


#pragma mark - Public Method

- (void)startScan
{
    [self.captureSession startRunning];
}

- (void)stopScan
{
    [self.captureSession stopRunning];
}

#pragma mark - Setup Video PreviewLayer

- (void)setupCaptureVideoPreviewLayer
{
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.bounds;
    [self.layer insertSublayer:layer above:0];
    [self bringSubviewToFront:self.scanAreaView];
}

#pragma mark - OverView

- (void)configurateOverView
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = CGRectGetMinX(self.scanAreaView.frame);
    CGFloat y = CGRectGetMinY(self.scanAreaView.frame);
    CGFloat w = CGRectGetWidth(self.scanAreaView.frame);
    CGFloat h = CGRectGetHeight(self.scanAreaView.frame);
    
    CGRect topOverRect = CGRectMake(0.0, 0.0, width, y);
    CGRect leftOverRect = CGRectMake(0.0, y, x, h);
    CGRect bottomOverRect = CGRectMake(0.0, CGRectGetMaxY(self.scanAreaView.frame), width, height-CGRectGetMaxY(self.scanAreaView.frame));
    CGRect rightOverRect = CGRectMake(x + w, y, x, h);
    
    for (NSValue *value in @[[NSValue valueWithCGRect:topOverRect],
                             [NSValue valueWithCGRect:leftOverRect],
                             [NSValue valueWithCGRect:bottomOverRect],
                             [NSValue valueWithCGRect:rightOverRect]])
    {
        [self setupOverView:[value CGRectValue]];
    }
}

- (void)setupOverView:(CGRect)frame
{
    UIView *overView = [[UIView alloc] initWithFrame:frame];
    overView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.5];;
    [self addSubview:overView];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if(metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects firstObject];
        if(self.delegate && [self.delegate respondsToSelector:@selector(qrcodeScanView:scanSuccessful:)])
        {
            [self.delegate qrcodeScanView:self scanSuccessful:metadataObj.stringValue];
        }
    }
}

#pragma mark - Rect Of Interest

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat x = (height - CGRectGetHeight(rect)) / 2 / height;
    CGFloat y = (width - CGRectGetWidth(rect)) / 2 / width;
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

#pragma mark - Getter && Setter


- (void)setBorderColor:(UIColor *)borderColor
{
    self.scanAreaView.borderColor = borderColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.scanAreaView.borderWidth = borderWidth;
}

- (UIView *)scanAreaView
{
    if(!_scanAreaView)
    {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat scanViewWidth = width - 2 * edge;
        CGFloat scanViewHeight = scanViewWidth;
        
        _scanAreaView = [[DSScanView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-scanViewWidth)*0.5,
                                                                     (CGRectGetHeight(self.bounds)-scanViewHeight)*0.5,
                                                                     scanViewWidth,
                                                                     scanViewHeight)];
        _scanAreaView.backgroundColor = [UIColor clearColor];
    }
    
    return _scanAreaView;
}

- (AVCaptureSession *)captureSession
{
    if(!_captureSession)
    {
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if([captureDevice hasFlash] && [captureDevice hasTorch])
        {
            [captureDevice lockForConfiguration:nil];
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
            [captureDevice setTorchMode:AVCaptureTorchModeAuto];
            [captureDevice unlockForConfiguration];
        }
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        output.rectOfInterest = [self rectOfInterestByScanViewRect:self.scanAreaView.frame];
        
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        
        if(input)
        {
            [_captureSession addInput:input];
        }
        
        if(output)
        {
            [_captureSession addOutput:output];
            NSMutableArray *array = [NSMutableArray array];
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
                [array addObject:AVMetadataObjectTypeQRCode];
            }
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
                [array addObject:AVMetadataObjectTypeEAN13Code];
            }
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
                [array addObject:AVMetadataObjectTypeEAN8Code];
            }
            if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
                [array addObject:AVMetadataObjectTypeCode128Code];
            }
            output.metadataObjectTypes = array;
        }
    }
    
    return _captureSession;
}

@end
