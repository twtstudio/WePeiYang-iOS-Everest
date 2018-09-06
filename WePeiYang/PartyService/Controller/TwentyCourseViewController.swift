//
//  TwentyCourseViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/17/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class TwentyCourseViewController: UIViewController {

    var cellTapped: Bool = false
    var currentRow = 0

    var courseList: [Courses.Study20?] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = .default

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            make in
            make.left.bottom.right.equalTo(self.view)
            make.left.top.equalTo(self.view).offset(92)
        }

        tableView.delegate = self
        tableView.dataSource = self

        //Eliminate the empty cells
        tableView.tableFooterView = UIView()

        Courses.getCourseList {
            self.courseList = Courses.courses

            self.tableView.reloadData()

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//TableView Delegate
extension TwentyCourseViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CourseTableViewCell(course: courseList[indexPath.row]!)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        Courses.Study20.getCourseDetail(of: (courseList[indexPath.row]?.courseID)!) {

            let details = Courses.Study20.courseDetails

            guard !details.isEmpty else {
//                MsgDisplay.showErrorMsg("这门课暂时没有详情噢！")
                return
            }

            let detailVC = TwentyCourseDetailViewController(details: details)

            self.navigationController?.show(detailVC, sender: nil)

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension TwentyCourseViewController {

    func expandCellToShowDetail() {

    }

    func collapseCellToHideDetail() {

    }
}
