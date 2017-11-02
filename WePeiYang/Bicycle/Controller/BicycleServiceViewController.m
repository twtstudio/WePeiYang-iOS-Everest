//
//  BicycleServiceViewController.m
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//
//
//#import "BicycleServiceViewController.h"
//#import "WePeiYang-Swift.h"
////#import "MsgDisplay.h"
//#define SMALL_ICON_WIDTH 30
//#define BIG_ICON_WIDTH 36
//@interface BicycleServiceViewController(){
//    CGFloat iconWidth;
//    CGFloat iconHight;
//}
//
//@property (strong, nonatomic) UILabel *titleLabel;
//@property (strong, nonatomic) UIImageView *mapIconImageView;
//@property (strong, nonatomic) UIImageView *infoIconImageView;
//@property (strong, nonatomic) UIImageView *notificationIconImageView;
////避免经常性的重复添加icon
//@property (nonatomic) BOOL didAddIcon;
//
//@end
//
//@implementation BicycleServiceViewController
//
//- (instancetype)init {
//    
//    self = [super init];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    if (self) {
//        self.viewControllerClasses = @[[BicycleServiceMapController class], [BicycleServiceInfoController class], [BicycleServiceNotificationController class]];
//        self.titles = @[@"", @"", @""];
//        self.keys = [@[@"type", @"type"] mutableCopy];
//        self.values = [@[@0, @1] mutableCopy];
//        
//        // customization
//        self.pageAnimatable = YES;
//        self.titleSizeSelected = 18.0;
//        self.titleSizeNormal = 15.0;
//        self.menuViewStyle = WMMenuViewStyleLine;
//        self.titleColorSelected = [UIColor whiteColor];
//        self.titleColorNormal = [UIColor darkGrayColor];
//        self.menuItemWidth = self.view.frame.size.width/3;
//        
//        self.bounces = YES;
//        self.menuHeight = 44;
//        self.menuViewBottomSpace = -(self.menuHeight + 64.0);
//        
//        self.didAddIcon = NO;
//        
//    }
//    return self;
//}
//
//- (void) viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    //NavigationBar 的文字
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    
//    //NavigationBar 的背景，使用了View
//    //self.navigationController.jz_navigationBarBackgroundAlpha = 0;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height)];
//    view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:101.0/255.0 alpha:1.0];
//    view.tag = 1;
//    [self.view addSubview:view];
//    
//    
//    //改变 statusBar 颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    
//    //添加 icon, 后加icon，才在上面
//    if (!self.didAddIcon){
//        [self addIcons];
//        self.didAddIcon = YES;
//    }
//    
//    //改变 notificationIcon
////    [NotificationList.sharedInstance getList:^(){
////        NSLog(@"1");
////        [self changeNotificationIcon];
////    }];
//}
//
//
//
//- (void)viewDidLoad {
//    
//    //MenuBar设置
//    self.menuBGColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:101.0/255.0 alpha:1.0];
//    self.progressColor = [UIColor colorWithRed:69.0/255.0 green:216.0/255.0 blue:146/255.0 alpha:1.0];
//    self.progressHeight = 3.0;
//    
//    //titleLabel设置
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.titleLabel.backgroundColor = [UIColor clearColor];
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = self.titleLabel;
//    self.titleLabel.text = @"地图";
//    [self.titleLabel sizeToFit];
//    
//    //特地的放在后面
//    [super viewDidLoad];
//    
//    
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    //BicycleUser.sharedInstance.bindCancel = NO;
//}
//
//
//
//- (void)addIcons {
//    
//    //设计icon的大小，计算icon的位置
//    iconWidth = SMALL_ICON_WIDTH;
//    iconHight = SMALL_ICON_WIDTH;
//    CGFloat x = self.view.frame.size.width/6 - iconWidth/2;
//    CGFloat y = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height+self.menuHeight/2-iconHight/2;
//    
//    //self.mapIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x-(BIG_ICON_WIDTH-SMALL_ICON_WIDTH)/2, y-(BIG_ICON_WIDTH-SMALL_ICON_WIDTH)/2, BIG_ICON_WIDTH, BIG_ICON_WIDTH)];
//    self.mapIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, iconWidth, iconHight)];
//    [self.mapIconImageView setImage:[UIImage imageNamed:@"地图"]];
//    self.infoIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+self.menuItemWidth, y, iconWidth, iconHight)];
//    [self.infoIconImageView setImage:[UIImage imageNamed:@"信息"]];
//    self.notificationIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+2*self.menuItemWidth, y, iconWidth, iconHight)];
//    [self.notificationIconImageView setImage:[UIImage imageNamed:@"公告"]];
//    
//    [self.view addSubview:self.mapIconImageView];
//    [self.view addSubview:self.infoIconImageView];
//    [self.view addSubview:self.notificationIconImageView];
//    
//}
//
//- (void)changeNotificationIcon {
//    
//    if (NotificationList.sharedInstance.didGetNewNotification) {
//        self.notificationIconImageView.image = [UIImage imageNamed:@"公告2"];
//    } else {
//        [self.notificationIconImageView setImage:[UIImage imageNamed:@"公告"]];
//    }
//}
//
//- (void)changeIconImageView:(UIImageView *)imageView width:(CGFloat)width {
//    if (imageView.frame.size.width == width){
//        return;
//    }
//    
//    CGFloat changeWidth = width-imageView.frame.size.width;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame = CGRectMake(imageView.frame.origin.x-changeWidth/2, imageView.frame.origin.y-changeWidth/2, width, width);
//    }];
//}
//
//- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
//    
//    //更改 NavigationBar 标题, 调整图标大小
//    if ([[info objectForKey:@"index"] integerValue] == 0) {
//        self.titleLabel.text = @"地图";
//        /*[self changeIconImageView:self.mapIconImageView width:BIG_ICON_WIDTH];
//        [self changeIconImageView:self.infoIconImageView width:SMALL_ICON_WIDTH];
//        [self changeIconImageView:self.notificationIconImageView width:SMALL_ICON_WIDTH];
//        */
//        self.navigationItem.rightBarButtonItem = nil;
//        
//    } else if ([[info objectForKey:@"index"] integerValue] == 1){
//        self.titleLabel.text = @"信息";
//        /*[self changeIconImageView:self.mapIconImageView width:SMALL_ICON_WIDTH];
//        [self changeIconImageView:self.infoIconImageView width:BIG_ICON_WIDTH];
//        [self changeIconImageView:self.notificationIconImageView width:SMALL_ICON_WIDTH];
//         */
//        
//        //刷新按钮
//        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshUserInfo)];
//        self.navigationItem.rightBarButtonItem = refreshButton;
//        
//        //用户绑定
//        if ([BicycleUser.sharedInstance.status isEqual:@0] && !BicycleUser.sharedInstance.bindCancel){
//            BicycleUserBindViewController *bindVC = [[BicycleUserBindViewController alloc] initWithNibName:@"BicycleUserBindViewController" bundle:nil];
//            //bindVC.jz_wantsNavigationBarVisible = NO;
//            [self.navigationController pushViewController:bindVC animated:YES];
//        }
//    } else {
//        self.titleLabel.text = @"公告";
//        /*[self changeIconImageView:self.mapIconImageView width:SMALL_ICON_WIDTH];
//        [self changeIconImageView:self.infoIconImageView width:SMALL_ICON_WIDTH];
//        [self changeIconImageView:self.notificationIconImageView width:BIG_ICON_WIDTH];
//         */
//        
//        self.navigationItem.rightBarButtonItem = nil;
//        
//        //处理 icon, 默认没有新消息
//        NotificationList.sharedInstance.didGetNewNotification = NO;
//        [self.notificationIconImageView setImage:[UIImage imageNamed:@"公告"]];
//    }
//    
//}
//
//- (void)refreshUserInfo {
//    BicycleServiceInfoController *infoVC = (BicycleServiceInfoController *)self.currentViewController;
//    [infoVC refreshInfo];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//-(BOOL)shouldAutorotate{
//    return NO;
//}
//
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return toInterfaceOrientation == UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//@end

