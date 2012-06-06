//
//  FSAppDelegate.h
//  FScreenBuilder
//
//  Created by My Lord Santoni on 06/06/12.
//  Copyright (c) 2012 EastPad. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
