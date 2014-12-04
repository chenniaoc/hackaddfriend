/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

// hook AppDelegate

%hook MicroMessengerAppDelegate
#import <UIKit/UIKit.h>

#import "MMUINavigationController.h"
#import "AddFriendEntryViewController.h"
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSArray *params = [[url query] componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    for (NSString *param in params) {
        NSArray *kv = [param componentsSeparatedByString:@"="];
        if (kv.count < 2) {
            break;
        }

        NSString *k = kv[0];
        NSString *v = kv[1];
        if (k && v) {
            paramDic[k] = v;
        }
    }
    
    
    
    MMUINavigationController *tabControl = (MMUINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//     tabControl.currentViewController;
    

	paramDic[@"tapbar"] = [tabControl description];
	
	
	UINavigationController *currentViewController = [tabControl performSelector:@selector(currentViewController) withObject:nil];
	paramDic[@"currentViewController"] = [currentViewController description];
	UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"拦截成功,参数如下" message:[paramDic description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	alertView.tag = 33434;
	objc_setAssociatedObject(alertView, @selector(alertView:clickedButtonAtIndex:), paramDic, OBJC_ASSOCIATION_RETAIN);
	
	[alertView show];
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 33434) {
    	MMUINavigationController *tabControl = (MMUINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;

 	Class afClass = NSClassFromString(@"AddFriendEntryViewController");
    	AddFriendEntryViewController *adObject = [[afClass alloc] init];
		
	NSDictionary *dic = objc_getAssociatedObject(alertView, @selector(alertView:clickedButtonAtIndex:));
	//UIView *friendsView = adObject.view;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       		UIView *&headerView = MSHookIvar<UIView*>(adObject,"m_headerSearchView");
		UIView *&searchBarUI = MSHookIvar<UIView*>(headerView,"m_searchBar");
		UISearchBar *&finalSearchBarView =  MSHookIvar<UISearchBar*>(searchBarUI,"m_searchBar");
		finalSearchBarView.text = @"475411112";	
		if (dic) {
			finalSearchBarView.text = dic[@"username"];
		}
		finalSearchBarView.text = dic[@"username"];
		NSLog(@"%p", searchBarUI);
		[searchBarUI performSelector:@selector(searchBarSearchButtonClicked:) withObject:nil];
	});
	//UIView *&headerView = MSHookIvar<UIView*>(adObject,"m_headerSearchView");//adObject.m_headerSearchView;	
	//UIView *&searchBarUI = MSHookIvar<UIView*>(headerView,"m_searchBar");
	//UISearchBar *&finalSearchBarView =  MSHookIvar<UISearchBar*>(searchBarUI,"m_searchBar");
	//finalSearchBarView.text = @"475411112";
	
	//NSLog(@"%p", searchBarUI);
	//NSLog(@"%p", friendsView);
	//NSLog(@"%p", finalSearchBarView);

	UINavigationController *currentViewController = [tabControl performSelector:@selector(currentViewController) withObject:nil];
	[currentViewController pushViewController:adObject animated:YES];
    }
}


%end

%hook AddFriendEntryViewController


%end
