//
//  BicycleFitnessTrackerViewController.swift
//  WePeiYang
//
//  Created by Allen X on 12/8/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

//import UIKit
//import HealthKitUI
//
//@available(iOS 9.3, *)
//class BicycleFitnessTrackerViewController: UIViewController {
//    let healthRingView = HKActivityRingView()
//    let healthSummary = HKActivitySummary()
//
//    let MoveColor = UIColor(red: 231.0/255.0, green: 23.0/255.0, blue: 61.0/255.0, alpha: 1)
//    let ExerciseColor = UIColor(red: 98/255.0, green: 228/255.0, blue: 42/255.0, alpha: 1)
//    let StandColor = UIColor(red: 34/255.0, green: 207/255.0, blue: 218/255.0, alpha: 1)
//
//    var tableView: UITableView!
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        //NavigationBar 的背景，使用了View
//        var bounds = self.navigationController!.navigationBar.bounds
//        bounds = CGRect(origin: bounds.origin, size: bounds.size)
//        bounds.offsetBy(dx: 0.0, dy: -20.0)
////        bounds.size.height += 20.0
//        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        visualEffectView.frame = bounds
//        visualEffectView.height += 20.0
//        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        //If this is not set to false, the back button won't work
//        visualEffectView.isUserInteractionEnabled = false
//        self.navigationController?.navigationBar.addSubview(visualEffectView)
//
//        //If visualEffectView does not get sent back, it'll cover "back" label
//        self.navigationController?.navigationBar.sendSubview(toBack: visualEffectView)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        for fooView in (self.navigationController?.navigationBar.subviews)! where fooView is UIVisualEffectView {
//            fooView.removeFromSuperview()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .black
//
//        //NavigationBar 的文字
//        self.navigationController!.navigationBar.tintColor = UIColor(red: 39.0/255.0, green: 174.0/255.0, blue: 27.0/255.0, alpha: 1)
//
//        tableView = UITableView()
//        tableView.backgroundColor = .black
//        tableView.separatorStyle = .none
//
//        //Eliminate the empty cells
//        tableView.tableFooterView = UIView(color: .clear)
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        //改变 statusBar 颜色
////        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
//        navigationController?.navigationBar.barStyle = .black
//
//        getActivitySummary()
//
//        computeLayout()
//
//        healthRingView.setActivitySummary(healthSummary, animated: true)
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func getActivitySummary() {
//
//        //Should create a query to access Health Store
//
//        healthSummary.activeEnergyBurned = HKQuantity(unit: HKUnit.calorie(), doubleValue: 450.0)
//        healthSummary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.calorie(), doubleValue: 400.0)
//        healthSummary.appleStandHours = HKQuantity(unit: HKUnit.count(), doubleValue: 10)
//        healthSummary.appleStandHoursGoal = HKQuantity(unit: HKUnit.count(), doubleValue: 12)
//        healthSummary.appleExerciseTime = HKQuantity(unit: HKUnit.minute(), doubleValue: 45)
//        healthSummary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minute(), doubleValue: 55)
//        //        healthRingView.backgroundColor = .whiteColor()
//        //        healthRingView.setActivitySummary(healthSummary, animated: true)
//    }
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//}
//
//@available(iOS 9.3, *)
//extension BicycleFitnessTrackerViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return (UIApplication.shared.keyWindow?.frame.size.width)!
//        }
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        switch indexPath.section {
//        case 0:
//            return BicycleFitnessTrackerViewCell(cellType: .Move(text: "Move", color: MoveColor))
//        case 1:
//            return BicycleFitnessTrackerViewCell(cellType: .Exercise(text: "Exercise", color: ExerciseColor))
//        case 2:
//            return BicycleFitnessTrackerViewCell(cellType: .Stand(text: "Stand", color: StandColor))
//        default:
//            return UITableViewCell()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if section != 0 {
//            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 4))
//            headerView.backgroundColor = UIColor.clear
//            return headerView
//        }
//
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: (UIApplication.shared.keyWindow?.frame.size.width)!))
//
//        let currentDate = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM, dd, yyyy"
//        let dateString = dateFormatter.string(from: currentDate)
//        let timeLabel = UILabel(text: dateString, color: .white)
//
//        headerView.addSubview(timeLabel)
//        timeLabel.snp.makeConstraints {
//            make in
//            make.centerX.equalTo(headerView)
//            make.top.equalTo(headerView).offset(15)
//        }
//
//        headerView.addSubview(healthRingView)
//        healthRingView.snp.makeConstraints {
//            make in
//            make.top.equalTo(timeLabel.snp.bottom).offset(15)
//            make.left.equalTo(headerView).offset(40)
//            make.right.equalTo(headerView).offset(-40)
//            make.height.equalTo(headerView.frame.width - 80)
//        }
//
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView(color: .clear)
//    }
//
//}
//
//@available(iOS 9.3, *)
//extension BicycleFitnessTrackerViewController {
//    func computeLayout() {
//        self.view.addSubview(tableView)
//        tableView.snp.makeConstraints {
//            make in
//            make.top.equalTo(self.view)
//            make.left.equalTo(self.view)
//            make.right.equalTo(self.view)
//            make.bottom.equalTo(self.view)
//        }
//    }
//}
