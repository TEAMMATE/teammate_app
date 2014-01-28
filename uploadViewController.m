//
//  uploadViewController.m
//  ui
//
//  Created by SengChia ching on 2014/1/28.
//  Copyright (c) 2014年 teammate. All rights reserved.
//

#import "uploadViewController.h"
#import "tabViewController.h"
#import "AppDelegate.h"
@interface uploadViewController ()
@end

@implementation uploadViewController
@synthesize allrecord;
@synthesize indexpath;
@synthesize status;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *app=[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Upload" inManagedObjectContext:app.managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc]init];
    [fetch setEntity:entity];
    NSArray *array=[app.managedObjectContext executeFetchRequest:fetch error:nil];
    allrecord=[[NSMutableArray alloc] init];
    for (NSManagedObjectContext *obj in array) {
        NSLog(@"nsobj=%@",[obj valueForKey:@"date"]);
        [allrecord addObject:obj];
    }
    NSLog(@"array=%lu",(unsigned long)[array count]);
    if ([array count]==0) {
        status.text=@"記錄都已上傳成功";
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    NSLog(@"allrecord=%d",[allrecord count]);
       return [allrecord count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"uploadcell";
    uploadCell *uploadcell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (CellIdentifier==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"uploadcell" owner:self options:nil];
        CellIdentifier=[nib objectAtIndex:0];
    }
    uploadcell.date.text=[NSString stringWithFormat:@"%@",[allrecord[indexPath.row]valueForKey:@"date"]];
    uploadcell.vsopp.text=[NSString stringWithFormat:@"%@",[allrecord[indexPath.row]valueForKey:@"title"]];
    uploadcell.scoreratio.text=[NSString stringWithFormat:@"%@",[allrecord[indexPath.row]valueForKey:@"score"]];
    NSLog(@"date=%@,vsopp=%@,scoreration=%@",[allrecord[indexPath.row]valueForKey:@"date"],[allrecord[indexPath.row]valueForKey:@"title"],[allrecord[indexPath.row]valueForKey:@"score"]);
    
    return uploadcell;
}
-(CGFloat)tableview:(UITableView*)tableview heightForRowAtindexPath:(NSIndexPath*)indexPath
{return 78;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"you select %drow",indexPath.row);
    UIAlertView *alerw=[[UIAlertView alloc]initWithTitle:@"確定上傳？" message:@"ready go?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"upload", nil];
    indexpath=indexPath.row;
    [alerw show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        AppDelegate *app=[[UIApplication sharedApplication]delegate];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Upload" inManagedObjectContext:app.managedObjectContext];
        NSFetchRequest *fetch=[[NSFetchRequest alloc]init];
        [fetch setEntity:entity];
        NSArray *array=[app.managedObjectContext executeFetchRequest:fetch error:nil];
        
        NSString *post =[[NSString alloc] initWithFormat:@"result=%@",[array[indexpath]valueForKey:@"json"]];
        NSLog(@"POST = %@",post);
        NSURL *url=[NSURL URLWithString:@"http://140.112.107.77/cgi/cgi_test.php"];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response==nil) {
            UIAlertView *alert2=[[UIAlertView alloc]initWithTitle:@"upload error" message:@"please check out if your network work" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert2 show];
        }else{
            [app.managedObjectContext deleteObject:array[indexpath]];
            uploadViewController *upload=[[uploadViewController alloc]init];
            [self presentViewController:upload animated:NO completion:nil];
            [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
    }
}
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)backplayerview:(id)sender {
    tabViewController *player=[self.storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
    [self presentViewController:player animated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    /*
     uploadViewController *uploadview=[self.storyboard instantiateViewControllerWithIdentifier:@"uploadview"];
     [self presentViewController:uploadview animated:YES completion:nil];
     [self.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
     */
}
@end
