//
//  WebViewController.h
//  Chiebukuro
//
//  Created by koogawa on 2013/12/01.
//  Copyright (c) 2013年 Kosuke Ogawa, Shingo Sato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end
