//
//  ViewController.m
//  prepareforrecord
//
//  Created by teammate on 13/9/24.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "presetViewController.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize quartertime;
@synthesize quartercount;
@synthesize teamname=_teamname;
@synthesize oneteam;
@synthesize allteam;
@synthesize pickopp;
//@synthesize connectoincase;
@synthesize congetallteam;
@synthesize congetteammember;
@synthesize oppname;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headtitle.title=@"設定比賽";
    AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Allteam" inManagedObjectContext:appdeleget.managedObjectContext];
    NSLog(@"presentemail=%@",appdeleget.useremail);
    if ([pickopp isEqual:NULL]) {
        [pickopp reloadAllComponents];
        NSLog(@"pickerview reload");
    }
    NSFetchRequest *fetch=[[NSFetchRequest alloc]init];
    [fetch setEntity:entity];
    NSArray *array=[appdeleget.managedObjectContext executeFetchRequest:fetch error:nil];
    allteam=[[NSMutableArray alloc]init];
    if ([array count]!=0) {
        for (NSManagedObjectContext *obj in array) {
            [allteam addObject:[obj valueForKey:@"teamschool"]];
            NSLog(@"obj=%@",[obj valueForKey:@"teamschool"]);
        }
    }
	// Do any additional setup after loading the view, typically from a nib.
    // [self getteam];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getteam];
    self.teamname =allteam;
  //  [pickopp reloadAllComponents];
  //  [pickopp selectRow:0 inComponent:0 animated:YES];
  //  NSLog(@"%@",self.teamname);
  //  AppDelegate *appdeleget=[[UIApplication sharedApplication]delegate];
  //  NSLog(@"teamID=%@",appdeleget.teamID);
    [self getteammember];
    
   
}
- (IBAction)reload:(id)sender {
    [pickopp reloadAllComponents];
    oppname.text=[NSString stringWithFormat:@"%@",allteam[0]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField ==quartercount){
        [textField resignFirstResponder];
        [quartertime becomeFirstResponder];
        [pickopp reloadAllComponents];

    }else if (textField==quartertime){
        [textField resignFirstResponder];
    }
    return YES;
}
//再點其他地方的時候把keyboard收起來
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [quartertime endEditing:YES];
    [quartercount endEditing:YES];
}

#pragma mark picker_view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.allteam.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.allteam[row];
}

- (IBAction)startgame:(id)sender {
    if ([quartercount.text isEqual:@""] ||  [quartertime.text isEqual:@""] ||[oppname.text isEqual:@""]) {
        UIAlertView *alertnotselect=[[UIAlertView alloc]initWithTitle:@"請完成所有填寫" message:@"沒有填好是要怎麼開始拉!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertnotselect show];
    }else{
    SelectPlayerViewController *select=[self.storyboard instantiateViewControllerWithIdentifier:@"selectplayerview"];
    //將三筆資料傳到下一個頁面去
    select.quarterlong=[quartertime.text intValue];
    select.quartercount=[quartercount.text intValue];
    select.oppname=self.oppname.text;
    //NSLog(@"%@",self.oppname.text);
    //NSLog(@"%@",select.oppname);
    select.myteamscoer=0;
    select.oppteamscore=0;
    select.quarternow=1;
    select.nowquarter=@"第一節";
    select.lasttime=[quartertime.text intValue]*60;
   // NSLog(@"%@==%@",[allteam objectAtIndex:3],[self.oppname.text]);
   // for (int i=1; [allteam objectAtIndex:i]==self.oppname.text; i++) {
   //     NSLog(@"i=%d%@",i,[allteam objectAtIndex:i]);
   // }
    NSLog(@"test=%lu",(unsigned long)([allteam indexOfObject:self.oppname.text]+1));
    select.oppteamID=[NSString stringWithFormat:@"%lu",(unsigned long)([allteam indexOfObject:self.oppname.text]+1)];
    [self.navigationController pushViewController:select animated:YES];
    }
}


- (IBAction)quarternumber:(id)sender {
    [self textFieldShouldReturn:quartercount];
    NSLog(@"%@",quartercount.text);
}

- (IBAction)onequartertime:(id)sender {
    [self textFieldShouldReturn:quartertime];
    NSLog(@"%@",quartertime.text);
}
/*- (IBAction)comfirm:(id)sender {
    if ([self.pickopp isHidden]) {
        [self.pickopp setHidden:NO];
    }else{
    [self.pickopp setHidden:YES];
    }
}
*/
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.oppname.text = [self.allteam objectAtIndex:row];
   // thePickerView.hidden = YES;
}
- (void)getteam{
    //AppDelegate *appdelegat=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *xtable=[[NSString alloc]initWithFormat:@"BASKET_TEAM"];
    
    NSString *post=[[NSString alloc]initWithFormat:@"var=2&table=%@",xtable];
    NSData * postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.112.107.77/cgi/xcode_retrive.php?"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    congetallteam = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (congetallteam) {
        NSLog(@"connection successful");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection== congetallteam) {
        data=[[NSMutableData alloc]init];
    }else if(connection==congetteammember)
    {
        datamember=[[NSMutableData alloc]init];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)thedata{
    if (connection== congetallteam) {
        [data appendData:thedata];
    }else if(connection==congetteammember){
        [datamember appendData:thedata];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==congetallteam) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible= NO;
    news=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [allteam removeAllObjects];//清空allteam
        //再拿一次
        for (oneteam in news) {
            //printf("%d\n",i,oneteam);
            NSLog(@"teamID=%@, teamschool=%@, teamname=%@",[oneteam valueForKey:@"teamID"],[oneteam valueForKey:@"teamSchool"],[oneteam valueForKey:@"teamName"]);
            [allteam addObject:[NSString stringWithFormat:@"%@%@",[oneteam valueForKey:@"teamSchool"],[oneteam valueForKey:@"teamName"]]];
            }
        //NSLog(@"%@",allteam);
        
        //取得本機端資料庫資料，以判別是否需要更新球隊
        AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSEntityDescription *entity1=[NSEntityDescription entityForName:@"Allteam" inManagedObjectContext:app.managedObjectContext];
        NSFetchRequest *fetch =[[NSFetchRequest alloc]init];
        [fetch setEntity:entity1];
        NSArray *array=[app.managedObjectContext executeFetchRequest:fetch error:nil];
        //殺掉資料庫有的資料
        for (NSManagedObjectContext *obj in array) {
            [app.managedObjectContext deleteObject:obj];
        }
        //在放新地進去
        for (int i=1;i<[allteam count];i++){
            NSEntityDescription *entity=[NSEntityDescription insertNewObjectForEntityForName:@"Allteam" inManagedObjectContext:app.managedObjectContext];
            [entity setValue:[NSNumber numberWithInt:i] forKey:@"teamID"];
            [entity setValue:allteam[i-1] forKey:@"teamschool"];
            //NSLog(@"%d%@",i,allteam[i-1]);
        }
        for (NSManagedObjectContext *obj in array) {
            NSLog(@"obj==%@",[obj valueForKey:@"teamschool"]);
        }
        // congetallteam =false;
    }else if (connection == congetteammember){
        
        newsteammember=[NSJSONSerialization JSONObjectWithData:datamember options:NSJSONReadingMutableContainers error:nil];
        //AppDelegate *appdelegat=[[UIApplication sharedApplication]delegate];
        NSDictionary *oneteammate=[[NSDictionary alloc]init];
        AppDelegate *appd=[[UIApplication sharedApplication]delegate];
        
        NSMutableArray *memberlist=[[NSMutableArray alloc]init];
        NSEntityDescription *entity1=[NSEntityDescription entityForName:@"Teammate" inManagedObjectContext:appd.managedObjectContext];
        NSFetchRequest *fetch=[[NSFetchRequest alloc]init];
        [fetch setEntity:entity1];
        NSArray *array=[appd.managedObjectContext executeFetchRequest:fetch error:Nil];
        for (NSManagedObjectContext *objk in array) {
            [appd.managedObjectContext deleteObject:objk];
        }
        NSString *photopath=@"http://140.112.107.77/images/";
        NSURL *defaulturl=[[NSURL alloc]initWithString:@"http://140.112.107.77/images/default.jpg"];
        NSData *defaultphotodata=[NSData dataWithContentsOfURL:defaulturl];
        int index=1;//存照片用的變數
        
        for (oneteammate in newsteammember) {
            if ([[oneteammate valueForKey:@"playerNum"]intValue]!=0) {
                NSString *teamplayername=[[NSString alloc]initWithFormat:@"%@",[oneteammate valueForKey:@"userName"]];
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:teamplayername,@"userName",[NSString stringWithFormat:@"%@",[oneteammate valueForKey:@"playerPos"]],@"playerPos",[NSString stringWithFormat:@"%@",[oneteammate valueForKey:@"playerNum"]],@"playerNum",[NSString stringWithFormat:@"%@",[oneteammate valueForKey:@"playerID"]],@"playerID",[NSString stringWithFormat:@"%@",[oneteammate valueForKey:@"userID"]],@"userID", nil];
                
                NSEntityDescription *entity=[NSEntityDescription insertNewObjectForEntityForName:@"Teammate" inManagedObjectContext:appd.managedObjectContext];
                [entity setValue:[NSNumber numberWithInt:[[dic valueForKey:@"playerID"]intValue]] forKey:@"playerID"];
                [entity setValue:teamplayername forKey:@"playername"];
                [entity setValue:[NSNumber numberWithInt:[[dic valueForKey:@"playerNum"]intValue]] forKey:@"playerNumber"];
                [entity setValue:[dic valueForKey:@"playerPos"] forKey:@"playerposition"];
                [entity setValue:[NSNumber numberWithInt:[[dic valueForKey:@"userID"]intValue]] forKey:@"userID"];
                NSURL *photourl=[[NSURL alloc]initWithString:[[photopath stringByAppendingString:[dic valueForKey:@"userID"]]stringByAppendingString:@".jpg"]];
                NSData *myphoto=[NSData dataWithContentsOfURL:photourl];
                if (myphoto !=nil) {
                    [self saveImage:[UIImage imageWithData:myphoto] path:0 userID:[dic valueForKey:@"userID"]];
                }else
                {
                    [self saveImage:[UIImage imageWithData:defaultphotodata] path:0 userID:[dic valueForKey:@"userID"]];
                }
                index=index+1;
                
                [memberlist addObject:dic];
                //[appdelegat.teammember addObject:oneteammate];
            }
        }
        /*
         NSURL *photourl=[[NSURL alloc]initWithString:[[photopath stringByAppendingString:[dict valueForKey:@"userID"]]stringByAppendingString:@".jpg"]];
         NSData *myphoto=[NSData dataWithContentsOfURL:photourl];
         if (myphoto !=Nil) {
         [playerphoto addObject:myphoto];
         } else{
         [playerphoto addObject:defaultphotodata];
         }
         */
        
        
        for (NSManagedObjectContext *obj in array) {
            NSLog(@"obj=====%@",[obj valueForKey:@"playername"]);
        }
        
       // NSLog(@"memberlist=%@",memberlist);
        congetteammember=false;
        appd.teammember=memberlist;
        if (appd.teamID !=NULL){
            NSLog(@"myteamname=%@",[allteam objectAtIndex:[appd.teamID intValue]-1]);
            appd.myteamname=[allteam objectAtIndex:[appd.teamID intValue]-1];
            
        }
    }
    
}

-(void)saveImage:(UIImage *)image path:(int)index userID:(NSString *)userID
{
    if (image!=nil) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory=[paths objectAtIndex:index];
        NSString *path=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",userID]];
        NSData *data=UIImageJPEGRepresentation(image, 0);
        [data writeToFile:path atomically:YES];
    }
}

-(UIImage *)loadimage:(int)index userID:(NSString *)userID
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *ducmentsDirectory =[paths objectAtIndex:index];
    NSString *path=[ducmentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",userID]];
    UIImage *image=[UIImage imageWithContentsOfFile:path];
    return image;
}


-(void)getteammember{
    AppDelegate *appdelegat=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //NSString *xtable=[[NSString alloc]initWithFormat:@"BASKET_TEAM"];
    
    NSString *post=[[NSString alloc]initWithFormat:@"var=2&table=USER as u, BASKET_PLAYER as p WHERE p.userID = u.userID AND p.teamID =%@",appdelegat.teamID];
    NSData * postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://140.112.107.77/cgi/xcode_retrive.php?"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    congetteammember = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (congetteammember) {
        NSLog(@"get teammember connection successful");
    }
    
}


@end
