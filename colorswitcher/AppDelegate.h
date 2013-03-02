//
//  AppDelegate.h
//  colorswitcher
//
//  Created by Valentin Filip on 5/19/12.
//  Copyright (c) 2012 Universitatea Babeș-Bolyai. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *fldOriginals;
@property (weak) IBOutlet NSTextField *fldDestination;
@property (weak) IBOutlet NSImageView *imgReference;
@property (weak) IBOutlet NSImageView *imgCurrent;
@property (weak) IBOutlet NSTextField *lblHueVal;
@property (weak) IBOutlet NSTextField *lblSatVal;
@property (weak) IBOutlet NSTextField *lblBrigVal;
@property (weak) IBOutlet NSTextField *lblContVal;
@property (weak) IBOutlet NSTextField *lblDone;
@property (weak) IBOutlet NSSlider *sliderHue;
@property (weak) IBOutlet NSSlider *sliderSat;
@property (weak) IBOutlet NSSlider *sliderBrightness;
@property (weak) IBOutlet NSSlider *sliderContrast;
@property (weak) IBOutlet NSLevelIndicator *levelIndicator;
@property (weak) IBOutlet NSButton *btnBrowseDest;
@property (weak) IBOutlet NSButton *btnBrowseRef;
@property (weak) IBOutlet NSButton *btnViewFiles;
@property (weak) IBOutlet NSButton *btnStart;
@property (weak) IBOutlet NSButton *btnResetView;
@property (weak) IBOutlet NSView *viewStage1;
@property (weak) IBOutlet NSView *viewStage2;
@property (weak) IBOutlet NSView *viewStage3;

- (IBAction)browseOriginals:(id)sender;
- (IBAction)browseDestination:(id)sende;
- (IBAction)browseReference:(id)sender;
- (IBAction)hueChanged:(id)sender;
- (IBAction)saturationChanged:(id)sender;
- (IBAction)brightnessChanged:(id)sender;
- (IBAction)contrastChanged:(id)sender;
- (IBAction)start:(id)sender;
- (IBAction)viewFiles:(id)sender;
- (IBAction)showStage1:(id)sender;
- (IBAction)resetView:(id)sender;

@end
