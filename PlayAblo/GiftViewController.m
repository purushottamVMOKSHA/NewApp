

#import "GiftViewController.h"

@interface GiftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GiftViewController

{
    NSArray *subTitleArray;
    NSString *daysOfCapacity;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    subTitleArray = @[@"Gift 1.",@"Gift 2.",@"Gift 3."];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0.99 green:0.30 blue:0.26 alpha:1.0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section? 1:subTitleArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        UILabel *label = (UILabel *)[cell viewWithTag:101];
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SubCell"];
        UILabel *mainLabel = (UILabel *)[cell viewWithTag:100];
        UILabel *subLabel = (UILabel *)[cell viewWithTag:101];
        UIView *holderView = (UIView *)[cell viewWithTag:511];
        holderView.layer.cornerRadius = 3;
        holderView.layer.masksToBounds = YES;
        
        mainLabel.text = subTitleArray[indexPath.row-1];
        if (indexPath.row == 1 && indexPath.section == 0) {
            subLabel.text = @"English";
            subLabel.hidden = NO;
            holderView.hidden = NO;
        }else {
            subLabel.hidden = YES;
            holderView.hidden = YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // [self.delegate NotificationVCSelectedMenuAtIndex:indexPath.row];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row?44:44;
}



@end
