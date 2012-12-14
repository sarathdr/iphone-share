//
//  socialShare.h
//  deadtone
//
//  Created by SARATH DR on 28/11/2012.
//
//

#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>



@interface socialShare : CDVPlugin


@property(nonatomic,retain) NSString* callbackId;

- init; 
- (void)showEmailComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showSMSComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showTwitter:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showFacebook:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

-(void) dealloc;
@end
