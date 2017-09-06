//
//  SubjectPrice.m
//  PlayAblo



#import "SubjectPrice.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <Razorpay/Razorpay.h>
#import <Razorpay/RazorpayPaymentCompletionProtocol.h>
#import "SubjectPriceModelData.h"
#import "Reachability.h"
#import "NetworkRechability.h"
// Static string object data
static NSString *const KEY_ID =@"rzp_test_1DP5mmOlF5G5ag";

//@"rzp_test_D7ZQXo32d7cwp0";
static NSString *const SUCCESS_TITLE = @"Success!";
static NSString *const SUCCESS_MESSAGE =
@"Your payment was successful. The payment ID is %@";
static NSString *const FAILURE_TITLE = @"Uh-Oh!";
static NSString *const FAILURE_MESSAGE =
@"Your payment failed due to an error.\nCode: %d\nDescription: %@";
static NSString *const EXTERNAL_METHOD_TITLE = @"Umm?";
static NSString *const EXTERNAL_METHOD_MESSAGE =
@"You selected %@, which is not supported by Razorpay at the moment.\nDo "
@"you want to handle it separately?";
static NSString *const OK_BUTTON_TITLE = @"OK";

@implementation SubjectPrice 

{
    UIView*view;
    UIControl *alphaview;
    AppDelegate*appdelegate;
    NSMutableArray*tableData;
    NSIndexPath *selectedIndex;
    
    // Razorpay object declaration
    Razorpay *razorpay;
    
    SubjectPriceModelData *spModel;
    NSMutableArray *spTableArray;
    NetworkRechability *network;
}
-(id)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    view=[[NSBundle mainBundle]loadNibNamed:@"SubPriceShowXIB" owner:self options:nil].lastObject;
    view.frame=self.bounds;
    [self addSubview:view];
    network=[[NetworkRechability alloc]init];
    [self subjectPriceDetailsData];
    
    return self;
}
-(void)initializeView
{
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds  = YES;
}

-(void)alphaintialiseview
{
    
    if (alphaview==nil)
    {
        alphaview=[[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
        alphaview.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
        [alphaview addSubview:view];
        
    }
    view.center=alphaview.center;
    view.layer.cornerRadius=6;
    _subjectNameLabelInXIB.text = self.subjectName;
    
    // Setting corner of XIB views
    _oneMonthsButtonOutlet.layer.cornerRadius = 5;
    _threeMonthsButtonOutlet.layer.cornerRadius = 5;
    _sixMonthsButtonOutlet.layer.cornerRadius = 5;
    _oneYearButtonOutlet.layer.cornerRadius = 5;
    _proceedButtonOutlet.layer.cornerRadius = 5;
    // _subXIBMaiViewOutlet.layer.cornerRadius = 5;
    _proceedButtonOutlet.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self->view addGestureRecognizer:singleTap];
    
    //    view.layer.borderColor = ([UIColor colorWithRed:255 green:.32 blue:.08 alpha:1]).CGColor;
    //    view.layer.borderWidth = 4.0f;
    
    
    appdelegate=[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:alphaview];
    view.backgroundColor=[UIColor whiteColor];
    
}

// Hide keypad
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.couponTextField resignFirstResponder];
    
}
// Hide keypad
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [_couponTextField resignFirstResponder];
        [self.couponTextField resignFirstResponder];
        
        
    }
}

// Close button action
- (IBAction)subShowPriceCloseButtonAction:(UIButton *)sender
{
    [alphaview removeFromSuperview];
}


// Payment button action
- (IBAction)paymentButtonAction:(UIButton *)sender
{
    if (network.checkRechability)
    {
    
        // Razorpay public key
        razorpay = [Razorpay initWithKey:@"rzp_live_ILgsfZCZoFIKMb" andDelegate:self];
        [razorpay setExternalWalletSelectionDelegate:self];
        
        // @"rzp_test_D7ZQXo32d7cwp0"
        NSString *couponString = self.couponTextField.text;
        NSLog(@"Coupon name:%@",couponString);
        
        UIImage *appImage = [UIImage imageNamed:@"1"];
        NSString *subName = self.subjectName;
        NSString *subPricePayment = @"17000";
        NSString *subTimeDuration = @"1 Months";
        NSString *priceCurrency = @"INR";
        
        NSDictionary *options = @{
                                  @"amount" :subPricePayment,
                                  @"currency" :priceCurrency,
                                  @"description" :subTimeDuration,
                                  @"image" :appImage,
                                  @"name" : subName,
                                  @"external" : @{@"wallets" : @[ @"paytm" ]},
                                  @"prefill" :
                                      @{@"email" : @"purushottam@gosharp.in", @"contact" : @"8553747760"},
                                  @"theme" : @{@"color" : @"#3594E2"}
                                  };
        
        [razorpay open:options];
        
    }
    else
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"No Internet!" message:@"Please Check your Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alt show];
    }

}

// Payment alert method
-(void)showPaymentAlert:(NSString*)title andMessage:(NSString *)message
{
    if ([[[UIDevice currentDevice] systemVersion]
         compare:@"8.0"
         options:NSNumericSearch] != NSOrderedAscending)
    {
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:message
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:OK_BUTTON_TITLE
                                 style:UIAlertActionStyleCancel
                               handler:nil];
        [alert addAction:cancelAction];
        
         [cancelAction setValue:[UIColor colorWithRed:255 green:.32 blue:.08 alpha:1] forKey:@"titleTextColor"];
        
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
           }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:OK_BUTTON_TITLE
                                              otherButtonTitles:nil];
        [alert show];
    }

}

// Payment succes alert method
-(void)onPaymentSucces:(NSString *)paymentID
{
    [self showPaymentAlert:SUCCESS_TITLE andMessage:[NSString
                                                     stringWithFormat:SUCCESS_MESSAGE, paymentID]];
}

// Payment error alert method
-(void)onPaymentError:(int)code description:(NSString *)str
{
    [self showPaymentAlert:FAILURE_TITLE
                  andMessage:[NSString
                              stringWithFormat:FAILURE_MESSAGE, code, str]];
}

// Payment data alert method
- (void)onExternalWalletSelected:(NSString *)walletName
                 WithPaymentData:(NSDictionary *)paymentData
{
    [self showPaymentAlert:EXTERNAL_METHOD_TITLE
                  andMessage:[NSString stringWithFormat:EXTERNAL_METHOD_MESSAGE,
                              walletName]];
}

// Subject pricing data
-(void)subjectPriceDetailsData
{
    spTableArray = [[NSMutableArray alloc]init];
    spModel = [[SubjectPriceModelData alloc]init];
    spModel.subMonths = @"1 Months";
    spModel.subPrice = @"RS 170";
    [spTableArray addObject:spModel];
    
    spModel = [[SubjectPriceModelData alloc]init];
    spModel.subMonths = @"3 Months";
    spModel.subPrice = @"RS 340";
    [spTableArray addObject:spModel];
    
    spModel = [[SubjectPriceModelData alloc]init];
    spModel.subMonths = @"6 Months";
    spModel.subPrice = @"RS 850";
    [spTableArray addObject:spModel];
    
    spModel = [[SubjectPriceModelData alloc]init];
    spModel.subMonths = @"1 Years";
    spModel.subPrice = @"RS 1750";
    [spTableArray addObject:spModel];
}

@end
