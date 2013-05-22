//
//  FSViewController.h
//  FScreenBuilder
//
//  Created by My Lord Santoni on 06/06/12.
//  Copyright (c) 2012 EastPad. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FSViewController : NSViewController

@property (nonatomic, strong) IBOutlet NSTextField *className;
//Data Source
@property (nonatomic, strong) IBOutlet NSTextField *dataSourceAttribut;
@property (nonatomic, strong) IBOutlet NSTextField *dataSourceClass;

//Application Delegate
@property (nonatomic, strong) IBOutlet NSButton *appDelegateUse;
@property (nonatomic, strong) IBOutlet NSTextField *appDelegateAttribut;
@property (nonatomic, strong) IBOutlet NSTextField *appDelegateClass;

//Custom Cell
@property (nonatomic, strong) IBOutlet NSButton *customCellUse;
@property (nonatomic, strong) IBOutlet NSTextField *customCellAttribut;
@property (nonatomic, strong) IBOutlet NSTextField *customCellClass;
@property (nonatomic, strong) IBOutlet NSTextField *customCellNib;

@property (nonatomic, strong) IBOutlet NSMatrix *loadingMethod;
@property (nonatomic, strong) IBOutlet NSMatrix *classStyle;

@property (nonatomic, strong) IBOutlet NSButton *generateButton;


- (IBAction)buttonClicked:(id)sender;
- (IBAction)includeApplicationDelegateWasPressed:(NSButton *)sender;

@end