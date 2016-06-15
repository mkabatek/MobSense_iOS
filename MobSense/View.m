//
//  View.m
//  MobSense
//
//  Created by Michael Kabatek on 06/08/16.
//  Copyright (c) 2016 stream^N Inc. All rights reserved.
//

#import "View.h"

int x, y;
double diameter;
double diameter0;
double centerx;
double centery;
double centerx0;
double centery0;
CGRect state0Rect;
CGRect state1Rect;
CGRect state2Rect;
CGRect boundingBox;
CAShapeLayer *layer;
CABasicAnimation *animation;
CAShapeLayer *shape0;
CAShapeLayer *shape1;
CAShapeLayer *shape2;
//bool enabled = NO;
NSUserDefaults *defaults;
extern Boolean *enabled;

@implementation View

+ (Class)layerClass {
    return [CAShapeLayer class];
}


@synthesize enabled;


- (void)layoutSubviews {
    [super layoutSubviews];
     //NSLog(@"layoutSubviews called");
    
    
}

- (void)drawRect:(CGRect)rect {
    
    defaults = [NSUserDefaults standardUserDefaults];
    enabled = [defaults boolForKey:@"enabled"];
    
    NSLog(@"drawRect called");
    NSLog(@"current state %d", enabled);
    
    //setup function to setup the custom button
    //call attach image layer method to setup the image
    [self attachImageLayer];
    //setup inital conditions for the animation path
    [self attachPathAnimation];
    //add a button listener to do something when click is recived
    [self addTarget:self action:@selector(buttonToggle) forControlEvents:(UIControlEventTouchUpInside)];
    //cast this this view to shape layer and change fill and BG color for animations
    CAShapeLayer *shape =(CAShapeLayer *)self.layer;
    shape.fillColor = [UIColor colorWithRed:0.84 green:0.25 blue:0.21 alpha:1.0].CGColor;
    shape.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;




}





- (void)attachImageLayer {
    
    
    
        //Image layer for main circle
        if(enabled){
            diameter = 2560;
        }
        else{
            diameter = self.bounds.size.width*2/3;
        }
    
    
        centerx = (self.bounds.size.width-diameter)/2;
        centery = (self.bounds.size.height-diameter)/2;
        boundingBox = CGRectMake(centerx, centery, diameter, diameter);
    
        shape0 =[CAShapeLayer layer];
        shape0.path = [UIBezierPath bezierPathWithOvalInRect:boundingBox].CGPath;
        shape0.fillColor = [UIColor colorWithRed:0.84 green:0.25 blue:0.21 alpha:1.0].CGColor;
        [self.layer insertSublayer:shape0 atIndex:1];
    
    
        //image layer for logo
        diameter = self.bounds.size.width*2/3;
        centerx = (self.bounds.size.width-diameter)/2;
        centery = (self.bounds.size.height-diameter)/2;
        boundingBox = CGRectMake(centerx, centery, diameter, diameter);
    
        shape1 =[CAShapeLayer layer];
        shape1.frame = self.bounds;
        shape1.bounds = boundingBox;
        if(enabled){
            shape1.contents = (id) [UIImage imageNamed:@"ic_waveform_on.png"].CGImage;
        }
        else{
            shape1.contents = (id) [UIImage imageNamed:@"ic_waveform_off.png"].CGImage;
        }
        shape1.fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0].CGColor;
        [self.layer insertSublayer:shape1 atIndex:2];
    
        //image layer for background
        shape2 =[CAShapeLayer layer];
        shape2.frame = self.bounds;
        shape2.bounds = self.bounds;
        shape2.fillColor = [UIColor colorWithRed:0.0 green:0.00 blue:0.00 alpha:0.0].CGColor;
    
        [self.layer insertSublayer:shape2 atIndex:0];
    
    
    
}


- (void)attachPathAnimation {
    
    
    centerx = (self.bounds.size.width-diameter)/2;
    centery = (self.bounds.size.height-diameter)/2;
    state1Rect = CGRectMake(centerx, centery, diameter, diameter);
    CABasicAnimation *animation = [self animationWithKeyPath:@"path"];
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:state1Rect].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:animation.keyPath];

    
}

- (void)attachInAnimation {
    
    [self.layer removeAllAnimations];
    
    shape1.contents = (id) [UIImage imageNamed:@"ic_waveform_off.png"].CGImage;

    
    //This is some super hacky stuff to get the state of the button to close correctly
    //Not sure why but you need to remove the circle layer and re-ad it with the smaller bounding box
    //otherwise the circle will not animate closed
    [shape0 removeFromSuperlayer];
    diameter = self.bounds.size.width*2/3;
    centerx = (self.bounds.size.width-diameter)/2;
    centery = (self.bounds.size.height-diameter)/2;
    boundingBox = CGRectMake(centerx, centery, diameter, diameter);
    
    shape0 =[CAShapeLayer layer];
    shape0.path = [UIBezierPath bezierPathWithOvalInRect:boundingBox].CGPath;
    shape0.fillColor = [UIColor colorWithRed:0.84 green:0.25 blue:0.21 alpha:1.0].CGColor;
    [self.layer insertSublayer:shape0 atIndex:1];
    
     
     
    diameter = 2560;
    centerx = (self.bounds.size.width-diameter)/2;
    centery = (self.bounds.size.height-diameter)/2;
    state1Rect = CGRectMake(centerx, centery, diameter, diameter);
    
    
    diameter = self.bounds.size.width*2/3;
    centerx = (self.bounds.size.width-diameter)/2;
    centery = (self.bounds.size.height-diameter)/2;
    state0Rect = CGRectMake(centerx, centery, diameter, diameter);

    CABasicAnimation *animation = [self animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(state1Rect, 0, 0)].CGPath;
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(state0Rect, 0, 0)].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.speed *= 2.5;
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

- (void)attachOutAnimation {
    
    [self.layer removeAllAnimations];
    
    shape1.contents = (id) [UIImage imageNamed:@"ic_waveform_on.png"].CGImage;
    
    diameter = 2560;
    centerx = (self.bounds.size.width-diameter)/2;
    centery = (self.bounds.size.height-diameter)/2;
    state1Rect = CGRectMake(centerx, centery, diameter, diameter);

    
    diameter = self.bounds.size.width*2/3;
    centerx = (self.bounds.size.width-diameter)/2;
    centery = (self.bounds.size.height-diameter)/2;
    state0Rect = CGRectMake(centerx, centery, diameter, diameter);
    
    CABasicAnimation *animation = [self animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(state0Rect, 0, 0)].CGPath;
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectInset(state1Rect, 0, 0)].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

- (void)attachColorAnimation {
    CABasicAnimation *animation = [self animationWithKeyPath:@"fillColor"];
    animation.fromValue = (__bridge id)[UIColor colorWithHue:0 saturation:.9 brightness:.9 alpha:1].CGColor;
    [self.layer addAnimation:animation forKey:animation.keyPath];
}

- (CABasicAnimation *)animationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.autoreverses = NO;
    animation.repeatCount = 0;
    animation.duration = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    return animation;
}





- (void)buttonToggle{
    
    
    

    if(enabled){
        [self attachInAnimation];
        NSLog(@"In animation called");
        
        
    }
    else{
        
        [self attachOutAnimation];
        NSLog(@"Out animation called");
        
    }
    enabled = !enabled;

    [defaults setBool:enabled forKey:@"enabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"current state %d", enabled);


}


@end






