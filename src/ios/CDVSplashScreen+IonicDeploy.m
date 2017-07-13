#import "CDVSplashScreen+IonicDeploy.h"
#import <objc/runtime.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVScreenOrientationDelegate.h>

@implementation CDVSplashScreen(Deploy)

- (void)swizzled_setvisible:(BOOL)visible andForce:(BOOL)force
{
    NSLog(@"SWIZZLED SETVIS");
    [self swizzled_setvisible:visible andForce:force];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setVisible: andForce:);
        SEL swizzledSelector = @selector(swizzled_setvisible: andForce:);
        
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
@end