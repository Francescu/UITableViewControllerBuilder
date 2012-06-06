//
//  FSViewController.m
//  FScreenBuilder
//
//  Created by My Lord Santoni on 06/06/12.
//  Copyright (c) 2012 EastPad. All rights reserved.
//

#import "FSViewController.h"

@interface FSViewController ()

@end

@implementation FSViewController
@synthesize className, dataSourceClass, dataSourceAttribut, appDelegateUse, appDelegateClass,appDelegateAttribut, customCellUse, customCellClass, customCellAttribut, classStyle, loadingMethod, generateButton, customCellNib;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)loadView
{
    [super loadView];
    //[self.generateButton setTarget:self];
    //[self.generateButton setAction:@selector(generateButtonWasPressed)];
}
- (IBAction)generateButtonWasPressed:(id)sender
{
    NSLog(@"OK");/*
    */
}
- (IBAction)buttonClicked:(id)sender
{
    NSLog(@"ok");
    NSString *headerFile = [self headerFileContent];
    NSString *mainFile = [self mainFileContent];
    
    NSSavePanel *op = [NSSavePanel savePanel];
    [op setNameFieldStringValue:[NSString stringWithFormat:@"%@.h",[self.className stringValue]]];
    
   /* [op setAllowsMultipleSelection:NO];
    [op setCanChooseDirectories:YES];
    [op setCanChooseFiles:NO];
    [op setCanCreateDirectories:YES];*/
    if ([op runModal] == NSOKButton)
    {
        NSURL *directory = [op directoryURL];
        NSMutableString *filePath = [NSMutableString string];
        [filePath appendString:[directory path]];
        NSLog(@"FilePath %@",filePath);
        
        NSString *mPath = [NSString stringWithFormat:@"%@/%@.m",filePath,[self.className stringValue]];
        NSString *hPath = [NSString stringWithFormat:@"%@/%@.h",filePath,[self.className stringValue]];
    
        [headerFile writeToFile:hPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [mainFile writeToFile:mPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
#warning Create UITableViewController Nib
#warning Create Custom Cell Nib
    }
}
- (NSString *)headerFileContent
{
    NSMutableString *content = [NSMutableString string];
    
    [content appendString:@"//                                  \n\
     //  %className%.h                   \n\
     //  Created by FScreenBuilder       \n\
     //                                  \n\
     \n\
     #import <UIKit/UIKit.h>             \n\
     \n"];
    
    NSMutableString *classes = [NSMutableString string];
    if (self.customCellUse.state == NSOnState && ![[self.customCellClass stringValue]  isEqualToString:@"UITableViewCell"])
    {
        [classes appendString:self.customCellClass.value];
    }
    if (self.appDelegateUse.state == NSOnState && ![[self.appDelegateClass stringValue] isEqualToString:@"UIApplicationDelegate"])
    {
        if (![classes isEqualToString:@""])
        {
            [classes appendString:@","];
        }
        [classes appendString:[self.appDelegateClass stringValue]];
    }
    if (![classes isEqualToString:@""])
    {
        [content appendFormat:@"@class %@;\n",classes];
    }
    [content appendString:@"\n\
     @interface %className% : %classStyle%\n\
     \n\
     @property (strong, nonatomic) %appDelegateClass% *%appDelegateAttribut%;\n\
     @property (strong, nonatomic) NSArray *%dataSourceAttribut%;\n\
     @property (nonatomic, assign) BOOL isLoading;\n"];
    if (![[[self.classStyle selectedCell] title] isEqualToString:@"UITableViewController"])
    {
        //IF !UITABLEVIEWCONTROLLER
        [content appendString:@"    @property (strong, nonatomic) IBOutlet UITableView *tableView;\n"];
    }
    
    //IF CustomCell
    if (self.customCellUse.state == NSOnState)
    {
        [content appendString:@"    @property (nonatomic, assign) IBOutlet %customCellClass% *%customCellAttribut%;\n"];
    }
#warning TODO : loading ComboBox
    /*
     //IF Loading == loadingCell
     @property (nonatomic, strong) IBOutlet UITableViewCell *loadingCell;
     //IF Loading == loadingView
     @property (nonatomic, strong) IBOutlet UIView *loadingView;
     
     */
    [content appendString:@"\
     \n@end"];
    
    NSString *final = content;
    final = [final stringByReplacingOccurrencesOfString:@"%className%" withString:[self.className stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%classStyle%" withString:[self.classStyle stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%customCellClass%" withString:[self.customCellClass stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%customCellAttribut%" withString:[self.customCellAttribut stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%appDelegateAttribut%" withString:[self.appDelegateAttribut stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%appDelegateClass%" withString:[self.appDelegateClass stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%dataSourceAttribut%" withString:[self.dataSourceAttribut stringValue]];
    return final;
    
}
- (NSString *)mainFileContent
{
    NSString *final = kMainFileTemplate;
    final = [final stringByReplacingOccurrencesOfString:@"%import_custom%" withString:[self importCustom]];
    final = [final stringByReplacingOccurrencesOfString:@"%synthesize_custom%" withString:[self synthesizeCustom]];
    
    if (self.appDelegateUse.state == NSOnState)
    {
        final = [final stringByReplacingOccurrencesOfString:@"%set_appDelegate%" withString:@"self.%appDelegateAttribut% = (%appDelegateClass% *)[UIApplication sharedApplication].delegate;\n"];
    }
    else {
        final = [final stringByReplacingOccurrencesOfString:@"%set_appDelegate%" withString:@""];
    }
    
#warning Set LoadingCell
    final = [final stringByReplacingOccurrencesOfString:@"%numberOfRows_check_loadingCell%" withString:@""];
    final = [final stringByReplacingOccurrencesOfString:@"%cellForRow_check_loadingCell%" withString:@""];
    
    final = [final stringByReplacingOccurrencesOfString:@"%cellForRow_content%" withString:[self cellForRowContent]];
    
    
    final = [final stringByReplacingOccurrencesOfString:@"%className%" withString:[self.className stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%classStyle%" withString:[self.classStyle stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%customCellClass%" withString:[self.customCellClass stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%customCellAttribut%" withString:[self.customCellAttribut stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%customCellNib%" withString:[self.customCellNib stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%appDelegateAttribut%" withString:[self.appDelegateAttribut stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%appDelegateClass%" withString:[self.appDelegateClass stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%dataSourceAttribut%" withString:[self.dataSourceAttribut stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%dataSourceClass%" withString:[self.dataSourceClass stringValue]];
    
    
    return final;
}
- (NSString *)importCustom
{
    NSMutableString *content = [NSMutableString string];
    if (self.appDelegateUse.state == NSOnState && ![[self.appDelegateClass stringValue] isEqualToString:@"UIApplicationDelegate"])
    {
        [content appendFormat:@"#import %@;\n",[self.appDelegateClass stringValue]];
    }
    
    if (self.customCellUse.state == NSOnState && ![[self.customCellClass stringValue] isEqualToString:@"UITableViewCell"])
    {
        [content appendFormat:@"#import %@;\n",[self.customCellClass stringValue]];
    }
    
    if (![[self.dataSourceClass stringValue] isEqualToString:@"NSString"])
    {
        [content appendFormat:@"#import %@;\n",[self.dataSourceClass stringValue]];
    }
    
#warning AsyncImageView & ASIFormRequest
    //%import_AsyncImageView%
    //%import_ASIFormRequest%
    return content;
}

- (NSString *)synthesizeCustom
{

    
    NSMutableString *content = [NSMutableString string];
    if (self.appDelegateUse.state == NSOnState)
    {
        [content appendFormat:@"@synthesize %@ = _%@;\n",[self.appDelegateAttribut stringValue],[self.appDelegateAttribut stringValue]];
    }
    
    if (self.customCellUse.state == NSOnState)
    {
        [content appendFormat:@"@synthesize %@ = _%@;\n",[self.customCellAttribut stringValue],[self.customCellAttribut stringValue]];
    }
    
    if (![[self.classStyle stringValue] isEqualToString:@"UITableViewController"])
    {
        [content appendString:@"@synthesize tableView = _tableView;\n"];
    }
    
#warning Synthesize Loading    
    /*
    %synthesize_loading%\*/
    return content;

  
}
- (NSString *)cellForRowContent
{
    NSString *content = @"      static NSString *CellIdentifier = @\"%className%Cell\";\n\
    %customCellClass% *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];\n\
    \n\
    if (cell == nil)\n\
    {\n\
        [[NSBundle mainBundle] loadNibNamed:@\"%customCellNib%\" owner:self options:nil];\n\
        cell = self.%customCellAttribut%;\n\
        self.%customCellAttribut% = nil;\n\
        //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@\"cellBackground.png\"]];\n\
    }\n\
    \n\
    %dataSourceClass% *item = (%dataSourceClass% *)[self.%dataSourceAttribut% objectAtIndex:indexPath.row];\n\
    // Configure the cell...\n\
    \n\
    //UILabel *label;\n\
    \n\
    //label = (UILabel *)[cell viewWithTag:12];\n\
    //label.text = item.name;\n\
    \n\
    return cell;\n";
    
    return content;
}
@end
