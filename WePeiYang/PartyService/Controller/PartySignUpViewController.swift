//
//  PartySignUpViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/18/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class PartySignUpViewController: UIViewController {

    var tableView: UITableView!
    let bgView = UIView(color: .partyRed)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;

        self.view.frame.size.width = (UIApplication.shared.keyWindow?.frame.size.width)!

        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor.white

        //NavigationBar 的背景，使用了View
//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;

        //改变 statusBar 颜色
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
//        navigationController?.navigationBar.barStyle = .black
        //改变背景颜色
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)

        tableView = UITableView()

        //Eliminate the empty cells
        tableView.tableFooterView = UIView()

        tableView.delegate = self
        tableView.dataSource = self

        self.fetchData()

        computeLayout()

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

extension PartySignUpViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = SignUpTableViewCell(status: ApplicantTest.ApplicantEntry.status, message: ApplicantTest.ApplicantEntry.message, hasEntry: ApplicantTest.ApplicantEntry.testInfo?.hasEntry, testIdentifier: 0)
            cell.selectionStyle = .none
                return cell
        case 1:
            let cell = SignUpTableViewCell(status: ApplicantTest.AcademyEntry.status, message: ApplicantTest.AcademyEntry.message, hasEntry: ApplicantTest.AcademyEntry.testInfo?.hasEntry, testIdentifier: 1)
            cell.selectionStyle = .none
                return cell

        case 2:
            let cell = SignUpTableViewCell(status: ApplicantTest.ProbationaryEntry.status, message: ApplicantTest.ProbationaryEntry.message, hasEntry: ApplicantTest.ProbationaryEntry.testInfo?.hasEntry, testIdentifier: 2)
            cell.selectionStyle = .none
            //log.word((ApplicantTest.ProbationaryEntry.message)!)/
            return cell

        default:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell

        }

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "结业考试"
        case 1:
            return "院级积极分子党校"
        case 2:
            return "预备党员党校"
        default:
            return nil
        }
    }

    /*
    func tableView_ tableView: UITableView, heightForFooterInSection section: Int -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: 5))
        return footerView
    }*/

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

}

// MARK: SnapKit layout computation
extension PartySignUpViewController {

    func computeLayout() {

        self.view.addSubview(bgView)
        bgView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.top).offset((self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
        }

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            make in
            make.top.equalTo(bgView.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
}

extension PartySignUpViewController {
    func fetchData() {
        ApplicantTest.ApplicantEntry.getStatus {
            if ApplicantTest.ApplicantEntry.status == nil {
                return
            }
            ApplicantTest.AcademyEntry.getStatus {
                if ApplicantTest.AcademyEntry.status == nil {
                    return
                }
                ApplicantTest.ProbationaryEntry.getStatus {
                    if ApplicantTest.ProbationaryEntry.status == nil {
                        return
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
