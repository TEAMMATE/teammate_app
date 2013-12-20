//
//  ViewController.m
//  testtableselect
//
//  Created by teammate on 13/10/3.
//  Copyright (c) 2013年 teammate. All rights reserved.
//

#import "SelectPlayerViewController.h"


@interface SelectPlayerViewController ()



@end

@implementation SelectPlayerViewController
@synthesize nowquarter;
@synthesize quartercount;
@synthesize quarterlong;
@synthesize oppname;

@synthesize playerID;
//variable
@synthesize myteamscoer;
@synthesize oppteamscore;
@synthesize quarternow;
@synthesize lasttime;
@synthesize oppteamID;

- (void)viewDidLoad
{
    checkpeople=0;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    player=[[NSMutableArray alloc]init];
    playerposition=[[NSMutableArray alloc]init];
    playernumber=[[NSMutableArray alloc]init];
    playerphoto=[[NSMutableArray alloc]init];
    playerID=[[NSMutableArray alloc]init];
    //這裡要寫要怎麼找到球員
   // player=[NSMutableArray arrayWithObjects:@"李建宏",@"蔡明訓",@"高小星",@"蔡沛軒",@"楊順堯",@"Lin",@"Ding",nil];
   // playerphoto=[NSMutableArray arrayWithObjects:@"Jason.jpg",@"Terry.jpg",@"Star.jpg",@"Ike.jpg",@"George.jpg",@"Lin.jpg",@"Ding.jpg", nil];
   // playerposition=[NSMutableArray arrayWithObjects:@"PF",@"PG",@"SF",@"C",@"SG",@"SG",@"c",nil];
   // playernumber=[NSMutableArray arrayWithObjects:@"8",@"21",@"15",@"0",@"24",@"7",@"23", nil];
   // playerID=[NSMutableArray arrayWithObjects:@"12",@"1",@"27",@"28",@"3",@"54",@"65",Nil];
    playerselected=[[NSMutableArray alloc]init];
    UITableView *allplayers=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-200)];
    self.title=@"選擇上場球員";
    allplayers.delegate=self;
    allplayers.dataSource=self;
    [self.view addSubview:allplayers];
    
    AppDelegate *appdeleget=[[UIApplication sharedApplication]delegate];
    NSMutableArray *teammmmmm=[[NSMutableArray alloc]init];
    teammmmmm= appdeleget.teammember;
    NSLog(@"teammmmmm=%@",[[teammmmmm valueForKey:@"userName"]objectAtIndex:1]);
    NSDictionary *dict=[[NSDictionary alloc]init];
    NSURL *defaulturl=[[NSURL alloc]initWithString:@"http://140.112.107.77/images/default.jpg"];
    NSData *defaultphotodata=[NSData dataWithContentsOfURL:defaulturl];

    for (dict in teammmmmm) {
        [player addObject:[dict valueForKey:@"userName"]];
        [playerposition addObject:[dict valueForKey:@"playerPos"]];
        NSLog(@"pos=%@",[dict valueForKey:@"playerPos"]);
        [playernumber addObject:[dict valueForKey:@"playerNum"]];
        NSLog(@"%@",[dict valueForKey:@"playerNum"]);
        [playerID addObject:[dict valueForKey:@"playerID"]];
        NSLog(@"%@",[dict valueForKey:@"userID"]);
        NSString *photopath=@"http://140.112.107.77/images/";
        NSURL *photourl=[[NSURL alloc]initWithString:[[photopath stringByAppendingString:[dict valueForKey:@"userID"]]stringByAppendingString:@".jpg"]];
        NSData *myphoto=[NSData dataWithContentsOfURL:photourl];
        if (myphoto !=Nil) {
            [playerphoto addObject:myphoto];
        } else{
            [playerphoto addObject:defaultphotodata];
            }

        NSLog(@"%@",[[photopath stringByAppendingString:[dict valueForKey:@"userID"]]stringByAppendingString:@".jpg"]);
        //playerphoto addObject:]
        //[player ]
    }
    /*
     NSURL *url=[[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://140.112.107.77/images/%@.jpg",appdeleget.userID]];
     NSData *mydata=[NSData dataWithContentsOfURL:url];
     userphoto.image=[UIImage imageWithData:mydata];
     */
    NSLog(@"Nmae=%@",player);
    NSLog(@"Pos=%@",playerposition);
    NSLog(@"number=%@",playernumber);
    NSLog(@"ID=%@",playerID);
   // NSLog(@"path=%@",playerphoto);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return player.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellideng =@"cell";
    PlayerCell *cell =[tableView dequeueReusableCellWithIdentifier:cellideng];
    
    if (cell==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"playercell" owner:self options:nil];
        cell =[nib objectAtIndex:0];
        
    }
    cell.nameLabel.text=[player objectAtIndex:indexPath.row];
    cell.Playerposition.text=[playerposition objectAtIndex:indexPath.row];
    cell.Playerphoto.image=[UIImage imageWithData:[playerphoto objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor redColor];
   // NSLog(@"%d",indexPath.row);
    //NSLog(@"count=%d",playerselected.count);
    for (int i=0; i<playerselected.count; i++) {
        int a=[[playerselected objectAtIndex:i]intValue];
        if (indexPath.row==a) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    //if cell is not check,
    //NSLog(@"indexPath: %i", indexPath.row);
    if (cell.accessoryType == UITableViewCellAccessoryNone && checkpeople<5){
        checkpeople++;
        NSLog(@"%d",checkpeople);
        
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
        [playerselected addObject:[NSNumber numberWithInt:indexPath.row]];
       
    }//else cell is check,
    else if (checkpeople==5 && cell.accessoryType==UITableViewCellAccessoryNone)
    {
        UIAlertView *alertpeoplefull =[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"人數已達上線" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertpeoplefull show];
    }
    else
    {
    
        checkpeople--;
        NSLog(@"%d",checkpeople);
        cell.accessoryType =UITableViewCellAccessoryNone;
        [playerselected removeObject:[NSNumber numberWithInt:indexPath.row]];
    }
    //NSLog(@"playerselected=%@",playerselected);
    
    [tableView selectRowAtIndexPath:indexPath
                           animated:YES
                     scrollPosition:UITableViewScrollPositionMiddle];
   
    
    //[tableView reload]
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

- (IBAction)gotorecordpage:(id)sender {
    //NSLog(@"%@",player[[playerselected[0]intValue]]);
    if (checkpeople != 5) {
        UIAlertView *alertpeopleless=[[UIAlertView alloc]initWithTitle:@"人數不足" message:@"請確定有選好五位先發球員" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertpeopleless show];
    }
    else{
        recordViewController *record=[self.storyboard instantiateViewControllerWithIdentifier:@"recordview"];
    
        record.awayname =oppname;
        record.quartercount =quartercount;
        record.quarterlong =quarterlong;
    
    
        record.playerphoto=[NSMutableArray arrayWithObjects:playerphoto[[playerselected[0]intValue]],playerphoto[[playerselected[1]intValue]],playerphoto[[playerselected[2]intValue]],playerphoto[[playerselected[3]intValue]],playerphoto[[playerselected[4]intValue]],nil];
        record.playername=[NSMutableArray arrayWithObjects:player[[playerselected[0]intValue]],player[[playerselected[1]intValue]],player[[playerselected[2]intValue]],player[[playerselected[3]intValue]],player[[playerselected[4]intValue]], nil];
        record.playernumber=[NSMutableArray arrayWithObjects:playernumber[[playerselected[0]intValue]],playernumber[[playerselected[1]intValue]],playernumber[[playerselected[2]intValue]],playernumber[[playerselected[3]intValue]],playernumber[[playerselected[4]intValue]], nil];
        record.personID=[NSMutableArray arrayWithObjects:playerID[[playerselected[0]intValue]],playerID[[playerselected[1]intValue]],playerID[[playerselected[2]intValue]],playerID[[playerselected[3]intValue]],playerID[[playerselected[4]intValue]], nil];
        NSLog(@"personID=%@",record.personID);
        
        record.opteamscore.text=[NSString stringWithFormat:@"%d",oppteamscore];
        
        record.awayname=oppname;
        //NSLog(@"This is record oppname:%@",record.awayname);
        //NSLog(@"This is selectview opname: %@",oppname);
        
        record.myscore=myteamscoer;
        record.oppscore=oppteamscore;
        //record.myteamscore.text=[NSString stringWithFormat:@"%d",myteamscoer];
        //record.opteamscore.text=[NSString stringWithFormat:@"%d",oppteamscore];
        record.quarternow=quarternow;
        record.nowquarter.text=[NSString stringWithFormat:@"%@",nowquarter];
        record.lastTime=lasttime;
        record.oppteamID=oppteamID;
        //record.myteamname.text=
    
    [self presentViewController:record animated:YES completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    }
}
-(void)getteammemberconnect{
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
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (con) {
        NSLog(@"connection successful");
    }
    
}

@end
