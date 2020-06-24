//
//  FFPullToLoadMoreView.m
//
//  Created by fairzy  on 13-8-26.
//  Copyright (c) 2013年 fairzy. All rights reserved.
//

#import "FFPullToLoadMoreView.h"

@implementation FFPullToLoadMoreView

#define TEXT_COLOR	 [UIColor colorWithRed:118.0f/255.0 green:118.0f/255.0 blue:118.0f/255.0 alpha:1.0]

@synthesize  loadingIndicator=_loadingIndicator;



- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 50.0f;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //
        //        CALayer *layer = [CALayer layer];
        //		layer.frame = CGRectMake(10, 10, 20.0f, 20.0f);
        //		layer.contentsGravity = kCAGravityResizeAspect;
        //		layer.contents = (id)[UIImage imageNamed:@"arrow.png"].CGImage;
        //
        //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        //		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        //			layer.contentsScale = [[UIScreen mainScreen] scale];
        //		}
        //#endif
        //
        //		[[self layer] addSublayer:layer];
        //		_arrowImage=layer;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width/2) - 10, 10, 20.0f, 20.0f);
        view.color = [UIColor redColor];
        [self addSubview:view];
        _loadingIndicator = view;
        //
        _loadState = FFPullToLoadMoreStateNormal;
    }
    return self;
}

#define FLIP_ANIMATION_DURATION 0.18f
- (void)setLoadState:(enum FFPullToLoadMoreState)state{
    if ( state == FFPullToLoadMoreStateLoading  ) {
        self.loadingIndicator.hidden = NO;
        [self.loadingIndicator startAnimating];
        
        //        [CATransaction begin];
        //        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        //        _arrowImage.hidden = YES;
        //        [CATransaction commit];
        //    }else if( state == FFPullToLoadMoreStateNormal ){
        //        self.loadingIndicator.hidden = YES;
        //        [self.loadingIndicator stopAnimating];
        //
        //        if (_loadState == FFPullToLoadMoreStatePulling) {
        //            [CATransaction begin];
        //            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
        //            _arrowImage.transform = CATransform3DIdentity;
        //            [CATransaction commit];
        //        }
        //
        //        [CATransaction begin];
        //        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        //        _arrowImage.hidden = NO;
        //        _arrowImage.transform = CATransform3DIdentity;
        //        [CATransaction commit];
    }else if( state == FFPullToLoadMoreStatePulling ){
        self.loadingIndicator.hidden = YES;
        [self.loadingIndicator stopAnimating];
        
        //        [CATransaction begin];
        //        [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
        //        _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        //        [CATransaction commit];
    }
    else{
        self.loadingIndicator.hidden = YES;
        [self.loadingIndicator stopAnimating];
    }
    
    _loadState = state;
}

#define SCROLL_H 50.0f
- (void)ffLoadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    if (_loadState == FFPullToLoadMoreStateLoading) {
        
    } else if (scrollView.isDragging) {
        
        BOOL _loading = NO;
        //if ([self.delegate respondsToSelector:@selector(hfLoadmoreViewDataSourceIsLoading)]) {
        _loading = [self.delegate ffPullToLoadMoreViewDataSourceIsLoading];
        //}
        
        float offset = scrollView.contentOffset.y + scrollView.frame.size.height;
        float boundery = scrollView.contentSize.height+SCROLL_H;
        if (_loadState == FFPullToLoadMoreStatePulling && offset < boundery && offset > scrollView.contentSize.height && !_loading) {
            [self setLoadState:FFPullToLoadMoreStateNormal];
        } else if (_loadState == FFPullToLoadMoreStateNormal &&offset > boundery && !_loading) {
            [self setLoadState:FFPullToLoadMoreStatePulling];
        }
    }
}

- (void)ffLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView{
    NSLog(@"egoRefreshScrollViewDidEndDragging:%@", NSStringFromCGPoint(scrollView.contentOffset));
    BOOL _loading = NO;
    //if ([_delegate respondsToSelector:@selector(ffPullToLoadMoreViewDataSourceIsLoading:)]) {
    _loading = [_delegate ffPullToLoadMoreViewDataSourceIsLoading];
    //}
    
    float offset = scrollView.contentOffset.y + scrollView.frame.size.height;
    float boundery = scrollView.contentSize.height;

    
    if ( offset >= boundery && !_loading) {
        if ([_delegate respondsToSelector:@selector(ffPullToLoadMoreViewDidTriggerRefresh)]) {
            [_delegate ffPullToLoadMoreViewDidTriggerRefresh];
        }
        
        [self setLoadState:FFPullToLoadMoreStateLoading];
    }
}


- (void)ffLoadMoreViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [self setLoadState:FFPullToLoadMoreStateNormal];
}


@end
