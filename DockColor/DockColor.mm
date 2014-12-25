#line 1 "/Users/iNasser/Desktop/DockColorTweak/DockColor/DockColor.xm"
#import <UIKit/UIKit.h>
#define PREFSFILENAME "com.inasser.dockcolor"

#define kDefaultWhiteColor [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]

#include <logos/logos.h>
#include <substrate.h>
@class SBDockView; 
static void (*_logos_orig$_ungrouped$SBDockView$layoutSubviews)(SBDockView*, SEL); static void _logos_method$_ungrouped$SBDockView$layoutSubviews(SBDockView*, SEL); 

#line 6 "/Users/iNasser/Desktop/DockColorTweak/DockColor/DockColor.xm"
BOOL enabled;
UIColor *color;
float BGalpha;
UIView *bGView;
UIView *viewToAdd;


static void _logos_method$_ungrouped$SBDockView$layoutSubviews(SBDockView* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBDockView$layoutSubviews(self, _cmd);
    if (enabled == YES) {
        
        bGView = MSHookIvar<UIView *>(self, "_backgroundView");
        bGView.alpha = BGalpha / 20.0;
        
         viewToAdd = [[UIView alloc] initWithFrame:bGView.frame];
         viewToAdd.backgroundColor = color;
        
         [bGView addSubview:viewToAdd];
}
}



static UIColor* parseColorFromPreferences(NSString* string) {
    NSArray *prefsarray = [string componentsSeparatedByString: @":"];
    NSString *hexString = [prefsarray objectAtIndex:0];
    double alpha = [[prefsarray objectAtIndex:1] doubleValue];
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [[UIColor alloc] initWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}
static void reloadPrefs() {
  
   CFPreferencesAppSynchronize(CFSTR(PREFSFILENAME));
   enabled =  !CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(PREFSFILENAME)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR(PREFSFILENAME))) boolValue];
    color =!CFPreferencesCopyAppValue(CFSTR("kColor"), CFSTR(PREFSFILENAME)) ? kDefaultWhiteColor : parseColorFromPreferences((id)CFPreferencesCopyAppValue(CFSTR("kColor"), CFSTR(PREFSFILENAME)));
BGalpha = !CFPreferencesCopyAppValue(CFSTR("alpha"), CFSTR(PREFSFILENAME)) ? 1 : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("alpha"), CFSTR(PREFSFILENAME))) floatValue];
    if (enabled == YES) {
        viewToAdd.backgroundColor = color;
         bGView.alpha = BGalpha / 20.0;
    }
    if (enabled == NO) {
        viewToAdd.backgroundColor = [UIColor clearColor];
        bGView.alpha = 1.0;
    }
}

static __attribute__((constructor)) void _logosLocalCtor_9a0ae2bb() {
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)reloadPrefs,
                                    CFSTR("com.inasser.dockcolor/prefschanged"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
   
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBDockView = objc_getClass("SBDockView"); MSHookMessageEx(_logos_class$_ungrouped$SBDockView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$SBDockView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$SBDockView$layoutSubviews);} }
#line 66 "/Users/iNasser/Desktop/DockColorTweak/DockColor/DockColor.xm"
