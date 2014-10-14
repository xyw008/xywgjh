//
//  BaseTableViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
////这个是本工程 UIViewcontroller 的基类

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initialize];
    }
    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setLeftBarbuttonTitle:(NSString *)titile
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backToPrevious)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backToPrevious
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initialize
{
    // Do any additional setup in subClass.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)showNodataIndicatorWithText:(NSString *)text image:(UIImage *)image
{
    CGFloat height = (self.searchDisplayController ? self.tableView.frame.size.height - 44 : self.tableView.frame.size.height);
    
    [self hideNodataIndicator];
    
    if (text)
    {
        
        self.nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 21)];
        self.nodataLabel.backgroundColor = [UIColor clearColor];
        self.nodataLabel.textColor = [UIColor grayColor];
        self.nodataLabel.text = text;
        self.nodataLabel.textAlignment = NSTextAlignmentCenter;
        self.nodataLabel.font = [UIFont systemFontOfSize:15.0];
        [self.tableView addSubview:self.nodataLabel];
        
        [self.nodataLabel sizeToFit];
        CGRect frame = self.nodataLabel.frame;
        frame.origin = CGPointMake((self.tableView.frame.size.width - frame.size.width)/2.0, (height - frame.size.height)/2.0);
        self.nodataLabel.frame = frame;
        
    }
    
    if (image)
    {
        self.nodataIcon = [[UIImageView alloc] initWithImage:image];
        [self.tableView addSubview:self.nodataIcon];
        
        [self.nodataIcon sizeToFit];
        CGFloat offset = (text ? 21 : 0);
        CGRect frame = self.nodataIcon.frame;
        frame.origin = CGPointMake((self.tableView.frame.size.width - frame.size.width)/2.0, (height - frame.size.height)/2.0 - offset);
        self.nodataIcon.frame = frame;
    }
}

- (void)hideNodataIndicator
{
    if (self.nodataLabel)
    {
        [self.nodataLabel removeFromSuperview];
        self.nodataLabel = nil;
    }
    
    if (self.nodataIcon)
    {
        [self.nodataIcon removeFromSuperview];
        self.nodataIcon = nil;
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
