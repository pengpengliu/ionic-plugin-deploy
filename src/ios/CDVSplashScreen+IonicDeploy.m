#import "CDVSplashScreen+IonicDeploy.h"
#import <objc/runtime.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVScreenOrientationDelegate.h>

@implementation CDVSplashScreen(Deploy)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(hide);
        SEL swizzledSelector = @selector(swizzled_hide);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)swizzled_hide:(CDVInvokedCommand*)command 
{
    NSLog(@"SWIZZLED HIDE");
    [self swizzled_hide];
}