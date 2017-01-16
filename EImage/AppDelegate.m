//
//  AppDelegate.m
//  EImage
//
//  Created by ELANCHOU on 1/16/17.
//  Copyright © 2017 ELANCHOU. All rights reserved.
//

#import "AppDelegate.h"
#import "DropFileViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSPopover *popover;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:-2];
    if (_statusItem){
        NSButton *statusBtn = _statusItem.button;
        statusBtn.image = [NSImage imageNamed:@"menu"];
        statusBtn.action = @selector(onStatusBarBtn:);
    }
    _popover = [[NSPopover alloc] init];
    _popover.contentViewController = [[DropFileViewController alloc] initWithNibName:@"DropFileViewController" bundle:nil];
    _popover.behavior = NSPopoverBehaviorTransient;
}

- (void)onStatusBarBtn:(id)sender
{
    if (_popover.shown){
        [_popover performClose:sender];
    }else{
        [_popover showRelativeToRect:_statusItem.button.bounds ofView:_statusItem.button preferredEdge:NSMinYEdge];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
