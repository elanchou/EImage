//
//  NSView+VisualEffect.m
//  EImage
//
//  Created by ELANCHOU on 18/01/2017.
//  Copyright © 2017 ELANCHOU. All rights reserved.
//

#import "NSView+VisualEffect.h"

@implementation NSView (VisualEffect)

- (instancetype)insertVibrancyViewBlendingMode:(NSVisualEffectBlendingMode)mode
{
    Class vibrantClass=NSClassFromString(@"NSVisualEffectView");
    if (vibrantClass)
    {
        NSVisualEffectView *vibrant=[[vibrantClass alloc] initWithFrame:self.bounds];
        [vibrant setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        // uncomment for dark mode instead of light mode
//        [vibrant setAppearance:[NSAppearance appearanceNamed:NSAppearanceNameVibrantDark]];
        [vibrant setBlendingMode:mode];
        [self addSubview:vibrant positioned:NSWindowBelow relativeTo:nil];
        
        return vibrant;
    }
    
    return nil;
}

- (void)removeVibrancyView
{
    [[self.subviews firstObject] removeFromSuperview];
}

@end
