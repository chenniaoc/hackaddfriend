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

@class MMUINavigationController;
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
    
    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"拦截成功,参数如下" message:[paramDic description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
    
    MMUINavigationController *tabControl = (MMUINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    
    [self.navigationController pushViewController:nil animated:YES];
    
	return YES;
}


%end
