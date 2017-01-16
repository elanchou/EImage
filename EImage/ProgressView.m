//
//  ProgressView.m
//  EImage
//
//  Created by ELANCHOU on 1/16/17.
//  Copyright © 2017 ELANCHOU. All rights reserved.
//

#import "ProgressView.h"

#define kAlphaWhiteColor [NSColor colorWithWhite:1.0 alpha:0.6]

@interface ProgressView()


@end

@implementation ProgressView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self){

    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPath];
    [bezierPath setLineWidth:2];
    
    NSPoint center = { self.bounds.size.height / 2.0 ,self.bounds.size.width / 2.0  };
    
    [bezierPath appendBezierPathWithArcWithCenter: center
                                     radius: 70
                                 startAngle: 0
                                   endAngle: 360 * self.progress];
    
    [kAlphaWhiteColor set];
    [bezierPath stroke];
    
}



@end
