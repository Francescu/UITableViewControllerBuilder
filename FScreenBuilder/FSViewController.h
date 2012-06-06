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

@property (nonatomic, strong) IBOutlet NSComboBox *loadingMethod;
@property (nonatomic, strong) IBOutlet NSMatrix *classStyle;

@property (nonatomic, strong) IBOutlet NSButton *generateButton;


- (IBAction)buttonClicked:(id)sender;

@end
#define kMainFileTemplate @"//\n\
//  %className%.m\n\
//  Created by FScreenBuilder\n\
//\n\
\n\
#import \"%className%.h\"\n\
\n\
%import_custom%\n\
\n\
@interface %className% ()\n\
\n\
@end\n\
\n\
@implementation %className%\n\
%synthesize_custom%\
@synthesize %dataSourceAttribut%    = _%dataSourceAttribut%;\n\
@synthesize isLoading           = _isLoading;\n\
\n\
- (id)init\n\
{\n\
self = [super initWithNibName:@\"%className%\" bundle:nil];\n\
if (self) {\n\
// Custom initialization\n\
%set_appDelegate%\
\n\
self.%dataSourceAttribut% = [NSArray array];\n\
}\n\
return self;\n\
}\n\
\n\
- (void)viewDidLoad\n\
{\n\
[super viewDidLoad];\n\
\n\
// Uncomment the following line to preserve selection between presentations.\n\
// self.clearsSelectionOnViewWillAppear = NO;\n\
\n\
// Uncomment the following line to display an Edit button in the navigation bar for this view controller.\n\
// self.navigationItem.rightBarButtonItem = self.editButtonItem;\n\
\n\
// Uncomment the following lines to change tableView Background Image\n\
//UIColor *background = [UIColor colorWithPatternImage:[UIImage imageNamed:@\"background.png\"]];\n\
//self.tableView.backgroundColor = background;\n\
\n\
}\n\
\n\
- (void)viewDidUnload\n\
{\n\
[super viewDidUnload];\n\
// Release any retained subviews of the main view.\n\
// e.g. self.myOutlet = nil;\n\
}\n\
\n\
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation\n\
{\n\
return (interfaceOrientation == UIInterfaceOrientationPortrait);\n\
}\n\
\n\
#pragma mark - Table view data source\n\
\n\
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView\n\
{\n\
// Return the number of sections.\n\
return 1;\n\
}\n\
\n\
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section\n\
{\n\
// Return the number of rows in the section.\n\
%numberOfRows_check_loadingCell%\
return [self.%dataSourceAttribut% count];\n\
}\n\
\n\
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath\n\
{\n\
%cellForRow_check_loadingCell%\n\
%cellForRow_content%\n\
}\n\
\n\
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath\n\
{\n\
return 44;\n\
}\n\
\n\
/*\n\
// Override to support conditional editing of the table view.\n\
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath\n\
{\n\
// Return NO if you do not want the specified item to be editable.\n\
return YES;\n\
}\n\
*/\n\
\n\
/*\n\
// Override to support editing the table view.\n\
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath\n\
{\n\
if (editingStyle == UITableViewCellEditingStyleDelete) {\n\
// Delete the row from the data source\n\
[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];\n\
}   \n\
else if (editingStyle == UITableViewCellEditingStyleInsert) {\n\
// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view\n\
}   \n\
}\n\
*/\n\
\n\
/*\n\
// Override to support rearranging the table view.\n\
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath\n\
{\n\
}\n\
*/\n\
\n\
/*\n\
// Override to support conditional rearranging of the table view.\n\
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath\n\
{\n\
// Return NO if you do not want the item to be re-orderable.\n\
return YES;\n\
}\n\
*/\n\
\n\
#pragma mark - Table view delegate\n\
/*\n\
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section\n\
{\n\
return @\"Section title\";\n\
}\n\
*/\n\
\n\
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath\n\
{\n\
// Navigation logic may go here. Create and push another view controller.\n\
/*\n\
<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@\"<#Nib name#>\" bundle:nil];\n\
// ...\n\
// Pass the selected object to the new view controller.\n\
[self.navigationController pushViewController:detailViewController animated:YES];\n\
*/    \n\
}\n\
@end"
