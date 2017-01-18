//
//  NSView+VisualEffect.h
//  EImage
//
//  Created by ELANCHOU on 18/01/2017.
//  Copyright © 2017 ELANCHOU. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (VisualEffect)

-(instancetype)insertVibrancyViewBlendingMode:(NSVisualEffectBlendingMode)mode;

- (void)removeVibrancyView;

@end
