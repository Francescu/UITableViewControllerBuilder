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
     NSString *final = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HeaderFileTemplate" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableString *classes = [NSMutableString string];
    if (self.customCellUse.state == NSOnState && ![[self.customCellClass stringValue]  isEqualToString:@"UITableViewCell"])
    {
        [classes appendString:[self.customCellClass stringValue]];
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
        classes = [NSMutableString stringWithFormat:@"@class %@;",classes];
    }
    final = [final stringByReplacingOccurrencesOfString:@"%classes%" withString:classes];
    
    NSMutableString *customProperty = [NSMutableString string];
    
    if (![[[self.classStyle selectedCell] title] isEqualToString:@"UITableViewController"])
    {
        //IF !UITABLEVIEWCONTROLLER
        [customProperty appendString:@"@property (strong, nonatomic) IBOutlet UITableView *tableView;\n"];
    }
    
    //IF CustomCell
    if (self.customCellUse.state == NSOnState)
    {
        [customProperty appendString:@"@property (nonatomic, assign) IBOutlet %customCellClass% *%customCellAttribut%;\n"];
    }

    NSString *loadingMethodValue = [[self.loadingMethod selectedCell] title];
    if ([loadingMethodValue isEqualToString:@"loadingCell"])
    {
        [customProperty appendString:@"@property (nonatomic, strong) IBOutlet UITableViewCell *loadingCell;\n"];
    }
    else if ([loadingMethodValue isEqualToString:@"loadingCell"])
    {
         [customProperty appendString:@"@property (nonatomic, strong) IBOutlet UIView *loadingView;\n"];
    }

    
    final = [final stringByReplacingOccurrencesOfString:@"%property_custom%" withString:customProperty];
    
    final = [final stringByReplacingOccurrencesOfString:@"%className%" withString:[self.className stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%classStyle%" withString:[[self.classStyle selectedCell] title]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%customCellClass%" withString:[self.customCellClass stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%customCellAttribut%" withString:[self.customCellAttribut stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%appDelegateAttribut%" withString:[self.appDelegateAttribut stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%appDelegateClass%" withString:[self.appDelegateClass stringValue]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%dataSourceAttribut%" withString:[self.dataSourceAttribut stringValue]];
    return final;
    
}

- (NSString *)mainFileContent
{
    #warning Add Remote Loading default function
    //NSString *final = kMainFileTemplate;
    NSString *final = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MainFileTemplate" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
                
    final = [final stringByReplacingOccurrencesOfString:@"%import_custom%" withString:[self importCustom]];
    final = [final stringByReplacingOccurrencesOfString:@"%synthesize_custom%" withString:[self synthesizeCustom]];
    
    if (self.appDelegateUse.state == NSOnState)
    {
        final = [final stringByReplacingOccurrencesOfString:@"%set_appDelegate%" withString:@"self.%appDelegateAttribut% = (%appDelegateClass% *)[UIApplication sharedApplication].delegate;\n"];
    }
    else {
        final = [final stringByReplacingOccurrencesOfString:@"%set_appDelegate%" withString:@""];
    }
    
    NSString *numberOfRows_check_loadingCell = @"";
    if ([[[self.loadingMethod selectedCell] title] isEqualToString:@"loadingCell"])
    {
        numberOfRows_check_loadingCell = @"if (self.isLoading)\n\
        {\n\
            return 1;\n\
        }\n";
    }
    
    final = [final stringByReplacingOccurrencesOfString:@"%numberOfRows_check_loadingCell%" withString:numberOfRows_check_loadingCell];
    
    final = [final stringByReplacingOccurrencesOfString:@"%cellForRow_check_loadingCell%" withString:[self cellForRowLoading]];
    
    final = [final stringByReplacingOccurrencesOfString:@"%cellForRow_content%" withString:[self cellForRowContent]];
    
    
    final = [final stringByReplacingOccurrencesOfString:@"%className%" withString:[self.className stringValue]];
    final = [final stringByReplacingOccurrencesOfString:@"%classStyle%" withString:[[self.classStyle selectedCell] title]];
    
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
        [content appendFormat:@"#import \"%@.h\"\n",[self.appDelegateClass stringValue]];
    }
    
    if (self.customCellUse.state == NSOnState && ![[self.customCellClass stringValue] isEqualToString:@"UITableViewCell"])
    {
        [content appendFormat:@"#import \"%@.h\"\n",[self.customCellClass stringValue]];
    }
    
    if (![[self.dataSourceClass stringValue] isEqualToString:@"NSString"])
    {
        [content appendFormat:@"#import \"%@.h\"\n",[self.dataSourceClass stringValue]];
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
    
    if (![[[self.classStyle selectedCell] title] isEqualToString:@"UITableViewController"])
    {
        [content appendString:@"@synthesize tableView = _tableView;\n"];
    }
    
    NSString *loadingMethodValue = [[self.loadingMethod selectedCell] title];
    if ([loadingMethodValue isEqualToString:@"loadingCell"])
    {
        [content appendString:@"@synthesize loadingCell = _loadingCell;\n"];
    }
    else if ([loadingMethodValue isEqualToString:@"loadingCell"])
    {
        [content appendString:@"@synthesize loadingView = _loadingView;\n"];
    }
    
    /*
    %synthesize_loading%\*/
    return content;

  
}
- (NSString *)cellForRowLoading
{
    if (![[[self.loadingMethod selectedCell] title] isEqualToString:@"loadingCell"])
    {
        return @"";
    }
    NSString *content = @"if (self.isLoading){\n\
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@\"LoadingCell\"];\n\
    if (cell == nil)\n\
    {\n\
        //[[NSBundle mainBundle] loadNibNamed:@\"%customCellNib%\" owner:self options:nil];\n\
        cell = self.loadingCell;\n\
        //self.%customCellAttribut% = nil;\n\
        //self.loadingCell = nil;\n\
        //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@\"loadingCellBackground.png\"]];\n\
    }\n\
    return cell;\n\
}";
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
