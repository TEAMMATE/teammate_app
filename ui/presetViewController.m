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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headtitle.title=@"設定比賽";
    //self.teamname =allteam;
    AppDelegate *appdeleget=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"presentemail=%@",appdeleget.useremail);
	// Do any additional setup after loading the view, typically from a nib.
   // [self getteam];
    }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getteam];
    self.teamname =allteam;
    [pickopp reloadAllComponents];
    [pickopp selectRow:0 inComponent:0 animated:YES];
    NSLog(@"%@",self.teamname);
    AppDelegate *appdeleget=[[UIApplication sharedApplication]delegate];
    NSLog(@"teamID=%@",appdeleget.teamID);
    [self getteammember];
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
    //NSLog(@"impicker");
    return self.allteam[row];
}

- (IBAction)startgame:(id)sender {
    SelectPlayerViewController *select=[self.storyboard instantiateViewControllerWithIdentifier:@"selectplayerview"];
    //將三筆資料傳到下一個頁面去
    select.quarterlong=[quartertime.text intValue];
    select.quartercount=[quartercount.text intValue];
    select.oppname=self.oppname.text;
    NSLog(@"%@",self.oppname.text);
    NSLog(@"%@",select.oppname);
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
    AppDelegate *appdelegat=(AppDelegate *)[[UIApplication sharedApplication]delegate];
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
    news=[NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    //NSLog(@"%@",[[news valueForKey:@"teamName"]objectAtIndex:1]);
    allteam=[[NSMutableArray alloc]init];
    int i=0;
    
    for (oneteam in news) {
        //printf("%d\n",i,oneteam);
        NSLog(@"%@%@%@",[oneteam valueForKey:@"teamID"],[oneteam valueForKey:@"teamSchool"],[oneteam valueForKey:@"teamName"]);
        [allteam addObject:[NSString stringWithFormat:@"%@%@",[oneteam valueForKey:@"teamSchool"],[oneteam valueForKey:@"teamName"]]];
        i++;
        }
       // congetallteam =false;
    }else if (connection == congetteammember){
        newsteammember=[NSJSONSerialization JSONObjectWithData:datamember options:Nil error:nil];
        AppDelegate *appdelegat=[[UIApplication sharedApplication]delegate];
        NSDictionary *oneteammate=[[NSDictionary alloc]init];
        
        NSLog(@"123456");
        NSLog(@"userName=%@",[newsteammember valueForKey:@"userName"]);
        NSLog(@"playerPos=%@",[newsteammember valueForKey:@"playerPos"]);
        NSLog(@"playerNum=%@",[newsteammember valueForKey:@"playerNum"]);
        NSMutableArray *memberlist=[[NSMutableArray alloc]init];
        for (oneteammate in newsteammember) {
            //NSLog(@"oneteamate valueforkey=%@",[oneteammate valueForKey:@"playerNum"]);
            if ([[oneteammate valueForKey:@"playerNum"]intValue]!=0) {
                NSLog(@"123=%@",[oneteammate valueForKey:@"playerNum"]);
                NSString *teamplayername=[[NSString alloc]initWithFormat:@"%@",[oneteammate valueForKey:@"userName"]];
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:teamplayername,@"userName",[NSString stringWithFormat:@"%@",[oneteammate valueForKey:@"playerPos"]],@"playerPos",[NSString stringWithFormat:@"%@",[oneteammate valueForKey:@"playerNum"]],@"playerNum",[NSString stringWithFormat:@"%@",[oneteammate valueForKey:@"userID"]],@"userID", nil];
                  NSLog(@"oneteammate=%@",[dic valueForKey:@"userName"]);
                  NSLog(@"dic=%@",dic);
                [memberlist addObject:dic];
                //[appdelegat.teammember addObject:oneteammate];
            }
        }
        NSLog(@"memberlist=%@",memberlist);
        AppDelegate *appd=[[UIApplication sharedApplication]delegate];
        congetteammember=false;
        appd.teammember=memberlist;
    }
    
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
        NSLog(@"get teammmember connection successful");
    }
    
}


@end
