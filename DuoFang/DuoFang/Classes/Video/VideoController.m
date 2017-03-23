//
//  VideoController.m
//  DuoFang
//
//  Created by Zhuge_Su on 2017/3/22.
//  Copyright © 2017年 Zhuge_Su. All rights reserved.
//

#import "VideoController.h"

@interface VideoController ()
@property (nonatomic, weak) CALayer *localVideoLayer;

@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self onLocalPreviewReady:self.localVideoLayer];
}

- (void)onLocalPreviewReady:(CALayer *)layer
{
    if (self.localVideoLayer) {
        [self.localVideoLayer removeFromSuperlayer];
    }
    self.localVideoLayer = layer;
    layer.frame = CGRectMake(150, 150, 100, 100);
    [self.view.layer addSublayer:layer];
}
@end
