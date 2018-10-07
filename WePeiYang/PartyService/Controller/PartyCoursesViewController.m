//
//  PartyCoursesViewController.m
//  WePeiYang
//
//  Created by Allen X on 8/16/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

#import "PartyCoursesViewController.h"
#import "WePeiYang-Swift.h"

#define partyRed [UIColor colorWithRed:240.0/255.0 green:22.0/255.0 blue:22.0/255.0 alpha:1]
#define partyPink [UIColor colorWithRed:255.0/255.0 green:64.0/255.0 blue:168.0/255.0 alpha:1]

@interface PartyCoursesViewController ()

@end

@implementation PartyCoursesViewController

- (instancetype)init {
    
    self = [super init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self) {
        //NSLog(@"FUCK");
        self.viewControllerClasses = @[[TwentyCourseViewController class], [TheoryClassicsTableViewController class]];
        NSLog(@"FUCKagain");
        self.titles = @[@"20课", @"预备党员理论经典"];
        //self.keys = [@[@"type", @"type"] mutableCopy];
        //self.values = [@[@1, @2] mutableCopy];
        
        // customization
        self.pageAnimatable = YES;
        self.titleSizeSelected = 16.0;
        self.titleSizeNormal = 14.0;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [UIColor whiteColor];
        self.menuItemWidth = self.view.frame.size.width/2;
        
        self.bounces = YES;
        //self.menuHeight = 44;
        self.menuViewBottomSpace = -(self.menuHeight + 64.0);
    }
    return self;
}

- (void)viewDidLoad {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"课程学习";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = titleLabel;
    
    //MenuBar设置
    self.menuBGColor = partyRed;
    self.progressColor = partyPink;
    self.progressHeight = 3.0;
    
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //NavigationBar 的文字
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //NavigationBar 的背景，使用了View
//    self.navigationController.jz_navigationBarBackgroundAlpha = 0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height)];
    view.backgroundColor = partyRed;
    view.tag = 1;
    [self.view addSubview:view];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

//改变 statusBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
