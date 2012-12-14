//
//  socialShare.m
//  deadtone
//
//  Created by SARATH DR on 28/11/2012.
//
//

#import "socialShare.h"

@implementation socialShare

@synthesize  callbackId;
NSString *successCallback = nil;



- (id) init
{
    return [super init];
}



- (void) showEmailComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
	NSString* subject = [arguments objectAtIndex:1];
	NSString* body = [arguments objectAtIndex:2];
    callbackId = [[arguments objectAtIndex:0] retain];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
	// Set subject
	if(subject != nil)
		[picker setSubject:subject];
	// set body
	if(body != nil)
	{
        [picker setMessageBody:body isHTML:YES];
        
    }
    
    
    // Attach an image to the email
	// NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
	//  NSData *myData = [NSData dataWithContentsOfFile:path];
	//  [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
    if (picker != nil) {
        [[ super viewController ] presentModalViewController:picker animated:YES];
    }
    [picker release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    
    [[ super viewController ] dismissModalViewControllerAnimated:YES];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    
    NSString* javaScript = nil;
    
    NSLog (@"%@",callbackId);
    
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
    
}



- (void) showSMSComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
    
	NSString* body = [arguments objectAtIndex:1];
    callbackId = [[arguments objectAtIndex:0] retain];
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    
	// set body
	if(body != nil)
	{
        picker.body = body;
        
    }
    
    
    // Attach an image to the email
	// NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
	//  NSData *myData = [NSData dataWithContentsOfFile:path];
	//  [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
    
    if (picker != nil) {
        [[ super viewController ] presentModalViewController:picker animated:YES];
    }
    [picker release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self.viewController dismissModalViewControllerAnimated:YES];
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    
    NSString* javaScript = nil;
    
    NSLog (@"%@",callbackId);
    
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
    
    
}

- (void) showTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    callbackId = [[arguments objectAtIndex:0] retain];
    NSString* tweetText = [arguments objectAtIndex:1];
    NSString* url       = [arguments objectAtIndex:2];
    
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    if(tweetViewController != nil)
    {
        [tweetViewController setInitialText:tweetText];
        [tweetViewController addURL:[NSURL URLWithString:url]];
        
        [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            [super.viewController dismissModalViewControllerAnimated:YES];
            
            CDVPluginResult* pluginResult = nil;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
            
            NSString* javaScript = nil;
            javaScript = [pluginResult toSuccessCallbackString:callbackId];
            [self writeJavascript:javaScript];
            
        }];
        
        [super.viewController presentModalViewController:tweetViewController animated:YES];
        [tweetViewController release];
    }
    else{
        
        CDVPluginResult* pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Twitter app is not installed"];
        
        NSString* javaScript = nil;
        javaScript = [pluginResult toErrorCallbackString:callbackId];
        [self writeJavascript:javaScript];
    }
    
}

- (void) showFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
    callbackId = [[arguments objectAtIndex:0] retain];
    
    NSString *fbText = [arguments objectAtIndex:1];
    NSString *webUrl = [arguments objectAtIndex:2];
    
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)webUrl,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8 );
    NSString *fbShareText =  [NSString stringWithFormat:@"%@%@%@%@", @"fb://publish?text=",fbText,@"%20" ,encodedString ];
    
    NSString *webFbUrlStr =  [NSString stringWithFormat:@"%@%@", @"http://www.facebook.com/sharer.php?u=", webUrl ];
    

    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:super.viewController 
                                                                    initialText:fbText
                                                                          image:nil
                                                                            url:[[NSURL alloc] initWithString:webUrl]
                                                                        handler:nil];
if (!displayedNativeDialog)
{
    NSURL *webFbUrl = [NSURL URLWithString:webFbUrlStr ];
    NSURL *theURL = [NSURL URLWithString:fbShareText ];
    
    if ([[UIApplication sharedApplication] canOpenURL:theURL])
    {
        [[UIApplication sharedApplication] openURL:theURL];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:webFbUrl];
    }
    
}
    
   
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    
    NSString* javaScript = nil;
    javaScript = [pluginResult toSuccessCallbackString:callbackId];
    [self writeJavascript:javaScript];
    
    
}


- (void) dealloc
{
	[super dealloc];
}






@end
