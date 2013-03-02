//
//  AppDelegate.m
//  colorswitcher
//
//  Created by Valentin Filip on 5/19/12.
//  Copyright (c) 2012 Universitatea Babeș-Bolyai. All rights reserved.
//
#include <ApplicationServices/ApplicationServices.h>
#include <QuartzCore/QuartzCore.h>
#include <Quartz/Quartz.h>
#include <QTKit/QTKit.h>
#import "AppDelegate.h"

@interface AppDelegate () {
    NSURL *urlOriginals;
    NSURL *urlDestination;
    NSImage *originalImage;
    NSArray *paths;
}

- (NSImage *)modifyImage:(NSImage *)originalImage;

@end



@implementation AppDelegate

@synthesize window = _window;
@synthesize fldOriginals = _fldOriginals;
@synthesize fldDestination = _fldDestination;
@synthesize imgReference = _imgReference;
@synthesize imgCurrent = _imgCurrent;
@synthesize lblHueVal = _lblHueVal;
@synthesize lblSatVal = _lblSatVal;
@synthesize lblBrigVal = _lblBrigVal;
@synthesize lblContVal = _lblContVal;
@synthesize lblDone = _lblDone;
@synthesize sliderHue = _sliderHue;
@synthesize sliderSat = _sliderSat;
@synthesize sliderBrightness = _sliderBrightness;
@synthesize sliderContrast = _sliderContrast;
@synthesize levelIndicator = _levelIndicator;
@synthesize btnBrowseDest = _btnBrowseDest;
@synthesize btnBrowseRef = _btnBrowseRef;
@synthesize btnViewFiles = _btnViewFiles;
@synthesize btnStart = _btnStart;
@synthesize btnResetView = _btnResetView;
@synthesize viewStage1 = _viewStage1;
@synthesize viewStage2 = _viewStage2;
@synthesize viewStage3 = _viewStage3;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self resetView:nil];
}

- (NSURL *)pickPathWithRoot:(NSString *)rootPath {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    openDlg.allowsMultipleSelection = NO;
    if (rootPath) {
        openDlg.directoryURL = [NSURL URLWithString:rootPath];
        openDlg.canChooseFiles = YES;
        openDlg.canChooseDirectories = NO;
        openDlg.canCreateDirectories = NO;
    } else {
        openDlg.canChooseFiles = NO;
        openDlg.canChooseDirectories = YES;
        openDlg.canCreateDirectories = YES;
    }
    
    if ([openDlg runModal] == NSOKButton) {
        NSArray* files = [openDlg URLs];
        return [files objectAtIndex:0];
    }
    return nil;
}

- (IBAction)browseOriginals:(id)sender {
    if (!(urlOriginals = [self pickPathWithRoot:nil])
        && (!self.fldOriginals.stringValue || [self.fldOriginals.stringValue isEqualToString:@""])) {
        [self resetView:nil];
        return;
    }
    
    if (urlOriginals) {
        [self.btnBrowseDest setEnabled:YES];
        NSString *path = urlOriginals.absoluteString;
        path = [path stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
        
        self.fldOriginals.stringValue = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

- (IBAction)browseDestination:(id)sender {
    if(!(urlDestination = [self pickPathWithRoot:nil]) 
       && (!self.fldDestination.stringValue || [self.fldDestination.stringValue isEqualToString:@""])) 
    {
        [self.btnBrowseRef setEnabled:NO];
        self.imgReference.image = nil;
        self.sliderHue.floatValue = 0;
        [self.sliderHue setEnabled:NO];
        self.lblHueVal.stringValue = @"0.0";
        self.sliderSat.floatValue = 1;
        [self.sliderSat setEnabled:NO];
        self.lblSatVal.stringValue = @"1.0";
        [self.btnStart setEnabled:NO];
        self.sliderBrightness.floatValue = 0;
        [self.sliderBrightness setEnabled:NO];
        self.lblBrigVal.stringValue = @"0.0";
        self.sliderContrast.floatValue = 1;
        [self.sliderContrast setEnabled:NO];
        self.lblContVal.stringValue = @"1.0";
        return;
    }
    if (urlDestination) {
        [self.btnBrowseRef setEnabled:YES];
        NSString *path = urlDestination.absoluteString;
        path = [path stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
        
        self.fldDestination.stringValue = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}

- (IBAction)browseReference:(id)sender {
    NSURL *path;
    if(!(path = [self pickPathWithRoot:urlOriginals.absoluteString])) {
        self.sliderHue.floatValue = 0;
        [self.sliderHue setEnabled:NO];
        self.lblHueVal.stringValue = @"0.0";
        self.sliderSat.floatValue = 1;
        [self.sliderSat setEnabled:NO];
        self.lblSatVal.stringValue = @"1.0";
        [self.btnStart setEnabled:NO];
        self.sliderBrightness.floatValue = 0;
        [self.sliderBrightness setEnabled:NO];
        self.lblBrigVal.stringValue = @"0.0";
        self.sliderContrast.floatValue = 1;
        [self.sliderContrast setEnabled:NO];
        self.lblContVal.stringValue = @"1.0";
        return;
    }
    
    [self.sliderHue setEnabled:YES];
    [self.sliderSat setEnabled:YES];
    [self.btnStart setEnabled:YES];
    [self.sliderBrightness setEnabled:YES];
    [self.sliderContrast setEnabled:YES];
    originalImage = [[NSImage alloc] initWithContentsOfURL:path];
    self.imgReference.image = [self modifyImage:originalImage];
}

- (IBAction)hueChanged:(id)sender {
    self.lblHueVal.stringValue = [NSString stringWithFormat:@"%0.4f", self.sliderHue.floatValue];
    self.imgReference.image = [self modifyImage:originalImage];
}

- (IBAction)saturationChanged:(id)sender {
    self.lblSatVal.stringValue = [NSString stringWithFormat:@"%0.4f", self.sliderSat.floatValue];
    self.imgReference.image = [self modifyImage:originalImage];
}

- (IBAction)brightnessChanged:(id)sender {
    self.lblBrigVal.stringValue = [NSString stringWithFormat:@"%0.4f", self.sliderBrightness.floatValue];
    self.imgReference.image = [self modifyImage:originalImage];
}

- (IBAction)contrastChanged:(id)sender {
    self.lblContVal.stringValue = [NSString stringWithFormat:@"%0.4f", self.sliderContrast.floatValue];
    self.imgReference.image = [self modifyImage:originalImage];
}

- (IBAction)start:(id)sender {
    [self.viewStage1 setHidden:YES];
    [self.viewStage3 setHidden:YES];
    
    [self.viewStage2 setHidden:NO];
    
    [self processImages];
}

- (IBAction)finishedProcessing {
    [self.viewStage1 setHidden:YES];
    [self.viewStage2 setHidden:YES];
    [self.viewStage3 setHidden:NO];
    [self.btnViewFiles becomeFirstResponder];
}

- (IBAction)viewFiles:(id)sender {
    NSArray *fileURLs = [NSArray arrayWithObjects:urlDestination, nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}

- (IBAction)showStage1:(id)sender {
    [self.viewStage1 setHidden:NO];
    [self.viewStage2 setHidden:YES];
    [self.viewStage3 setHidden:YES];  
}

- (IBAction)resetView:(id)sender {
    [self showStage1:nil];
    
    [self.btnBrowseDest setEnabled:NO];
    [self.btnBrowseRef setEnabled:NO];
    self.fldOriginals.stringValue = @"";
    self.fldDestination.stringValue = @"";
    self.imgReference.image = nil;
    self.sliderHue.floatValue = 0;
    [self.sliderHue setEnabled:NO];
    self.lblHueVal.stringValue = @"0.0";
    self.sliderSat.floatValue = 1;
    [self.sliderSat setEnabled:NO];
    self.lblSatVal.stringValue = @"1.0";
    self.sliderBrightness.floatValue = 0;
    [self.sliderBrightness setEnabled:NO];
    self.lblBrigVal.stringValue = @"0.0";
    self.sliderContrast.floatValue = 1;
    [self.sliderContrast setEnabled:NO];
    self.lblContVal.stringValue = @"1.0";
    [self.btnStart setEnabled:NO];
}

- (NSImage *)modifyImage:(NSImage *)origImage {
    CIImage *beginImage = [CIImage imageWithData:[[[NSBitmapImageRep alloc] initWithData:[origImage TIFFRepresentation]]
                                                  representationUsingType:NSPNGFileType 
                                                  properties:nil]];
    
    CIContext* context = [CIContext contextWithCGContext:nil options:nil];
    
    
    CIFilter* hueFilter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, beginImage, @"inputAngle", [NSNumber numberWithFloat:self.sliderHue.floatValue], nil];
    CIImage *outputImage = [hueFilter valueForKey:@"outputImage"];
    
    CIFilter* saturationFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, outputImage, @"inputSaturation", [NSNumber numberWithFloat:self.sliderSat.floatValue],
        @"inputBrightness", [NSNumber numberWithFloat:self.sliderBrightness.floatValue],
        @"inputContrast", [NSNumber numberWithFloat:self.sliderContrast.floatValue],nil];

    outputImage = [saturationFilter valueForKey:@"outputImage"];
        
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    NSImage *processed = [[NSImage alloc] initWithCGImage:cgimg size:origImage.size]; 
    
    CGImageRelease(cgimg);
    
    return processed;
}

- (void)processImages {
    paths = [[[self getPaths] allObjects] sortedArrayUsingSelector:@selector(compare:)];
    self.levelIndicator.maxValue = paths.count;
    
    [self processImageAtIndex:[NSNumber numberWithInt:0]];
}

- (void)processImageAtIndex:(NSNumber *)index {
    NSInteger idx = [index intValue];
    NSString *path = [paths objectAtIndex:idx];
    NSLog(@"Processing file: %@", path);
    
    NSString *imgPath = [[@"file://localhost" stringByAppendingString:path] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSImage *currentImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imgPath]];
    NSImage *modifiedImage = [self modifyImage:currentImage];
    self.imgCurrent.image = modifiedImage;
    
    NSData *imageData = [[[NSBitmapImageRep alloc] initWithData:[modifiedImage TIFFRepresentation]]
                         representationUsingType:NSPNGFileType 
                         properties:nil];
    NSString *relativePath = [path stringByReplacingOccurrencesOfString:self.fldOriginals.stringValue withString:@""];
    NSString *writePath = [self.fldDestination.stringValue stringByAppendingString:relativePath];
    
    NSError *error;
    if (![imageData writeToFile:writePath options:NSDataWritingAtomic error:&error]) {
        NSLog(@"Error writing file: %@", error);
    }
    
    self.levelIndicator.doubleValue = [index doubleValue];
    
    if (idx == paths.count-1) {
        [self finishedProcessing];
    } else {
        [self performSelector:@selector(processImageAtIndex:) withObject:[NSNumber numberWithLong:idx+1] afterDelay:0.08];
    }
}

- (NSSet *)getPaths {
    NSString *dir = self.fldOriginals.stringValue;
    NSMutableSet *contents = [[NSMutableSet alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    BOOL isDir;
    if (dir && ([fm fileExistsAtPath:dir isDirectory:&isDir] && isDir)) {
        if (![dir hasSuffix:@"/"]) {
            dir = [dir stringByAppendingString:@"/"];
        }
        
        NSDirectoryEnumerator *de = [fm enumeratorAtPath:dir];
        NSString *f;
        NSString *fqn;
        while ((f = [de nextObject])) {
            fqn = [dir stringByAppendingString:f];
            if ([fqn rangeOfString:self.fldDestination.stringValue].location != NSNotFound) {
                continue;
            }
            if ([fm fileExistsAtPath:fqn isDirectory:&isDir] && isDir) {
                fqn = [fqn stringByAppendingString:@"/"];
                
                NSString *folderPath = [self.fldDestination.stringValue 
                                        stringByAppendingString:[fqn stringByReplacingOccurrencesOfString:self.fldOriginals.stringValue 
                                                                                               withString:@""]];
                NSError * error = nil;
                [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&error];
            } else {
                if ([fqn rangeOfString:@".png"].location != NSNotFound) {
                    [contents addObject:fqn];
                }
            }
        }
        return contents;
    }
    
    printf("%s must be directory and must exist\n", [dir UTF8String]);
    return nil;   
}

@end
