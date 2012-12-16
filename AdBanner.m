/*
 *
 * Created by Mete Ozguz on 2012-05
 * Copyright Mete Ozguz 2012
 *
 * http://www.meteozguz.com
 * meteo158@gmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "AdBanner.h"


@implementation AdBanner
{
    ADBannerView *adBannerView;
}

-(id) init
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super" return value
    if( (self=[super init])) 
    {
        //Initialize the class manually to make it compatible with iOS < 4.0
        Class classAdBannerView = NSClassFromString(@"ADBannerView");
        if (classAdBannerView != nil) {
            adBannerView = [[classAdBannerView alloc] initWithFrame:CGRectZero];
            [adBannerView setDelegate:self];
            
            //Add the bannerView to the openGLView which is the view of our UIViewController
            [[[CCDirector sharedDirector] openGLView] addSubview:adBannerView];
            
            //Transform bannerView
            adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
            
            //Set bannerView to hidden so it shows only when it is loaded.
            [adBannerView setHidden:YES];
            
        }
        else{
            //No iAd Framework, iOS < 4.0
            CCLOG(@"No iAds avaiable for this version");
        }

    }
    return self;
}

#pragma mark -

#pragma mark ADBannerView

- (void)onEnter
{
    [super onEnter];
}
- (void)onExit
{      
    //Completely remove the bannerView
    [adBannerView setHidden:YES];
    [adBannerView setDelegate:nil];
    [adBannerView removeFromSuperview];
    [adBannerView release];
    adBannerView = nil;
    
    [super onExit];
}
#pragma mark -
#pragma mark ADBannerViewDelegate
- (BOOL)allowActionToRun
{
    return TRUE;
}
- (void) stopActionsForAd
{
    /* remember to pause music too! */
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] pause];
}
- (void) startActionsForAd
{
    /* resume music, if paused */
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    BOOL shouldExecuteAction = [self allowActionToRun];
    if (!willLeave && shouldExecuteAction)
    {
        // insert code here to suspend any services that might conflict with the advertisement
        [self stopActionsForAd];
    }
    return shouldExecuteAction;
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //Show the bannerView
    [adBannerView setHidden:NO];
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //Hide the bannerView if it fails to load
    [adBannerView setHidden:YES];
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    //Set the device orientation to cocos2d orientation
    //If I don’t do this, the interface gets stuck with portrait orientation when the ad finished showing for the first time.
    UIDeviceOrientation orientation = (UIDeviceOrientation)[[CCDirector sharedDirector] deviceOrientation];
    [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
    
    [self startActionsForAd];
}
@end
