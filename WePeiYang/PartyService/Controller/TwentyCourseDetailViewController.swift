//
//  TwentyCourseDetailViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/16/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class TwentyCourseDetailViewController: UITableViewController {

    var detailList: [Courses.Study20.Detail?] = []
    //var quizTakingBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Eliminate the empty cells
        tableView.tableFooterView = UIView()

//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;

        //FIXME: Autolayout and Scrolling is bad.
        let bgView = UIView(frame: CGRect(x: 0, y: -(self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height), width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
        //let bgView = UIView(color: partyRed)
        bgView.backgroundColor = .partyRed

        let quizTakingBtn = UIBarButtonItem(title: "开始答题", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TwentyCourseDetailViewController.startQuiz))

        self.navigationItem.setRightBarButton(quizTakingBtn, animated: true)

        //navigationItem.titleView?.addSubview(bgView)
        tableView.addSubview(bgView)
        /*bgView.snp.makeConstraints {
            make in
            make.left.equalTo(0)
            make.top.equalTo(-(self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
            make.right.equalTo((navigationController?.view)!.snp.right)
            make.height.equalTo(self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height)
        }*/

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for foo in navigationController!.view.subviews {
            if foo.isKind(of: CourseDetailReadingView.self) {
                foo.removeFromSuperview()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return detailList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CourseDetailTableViewCell(detail: detailList[indexPath.row]!)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let readingView = CourseDetailReadingView(detail: detailList[indexPath.row]!)

        self.navigationController?.view.addSubview(readingView)

        readingView.frame = CGRect(x: 0, y: self.view.frame.height, width: 0, height: self.view.frame.height/4)
        UIView.beginAnimations("readingViewPopUp", context: nil)
        UIView.setAnimationDuration(0.6)
        readingView.frame = self.view.frame
        UIView.commitAnimations()

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TwentyCourseDetailViewController {
    convenience init(details: [Courses.Study20.Detail?]) {

        self.init()
        self.detailList = details

    }
}

extension TwentyCourseDetailViewController {
    
    @objc func startQuiz() {

        let courseID = (self.detailList[0]?.courseID)!
        Courses.Study20.getQuiz(of: courseID) {
            let quizTakingVC = QuizTakingViewController(courseID: courseID)
            self.navigationController?.show(quizTakingVC, sender: nil)
        }
    }
}
