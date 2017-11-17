//
//  TheoryClassicsTableViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/16/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class TheoryClassicsTableViewController: UIViewController {

    var textList: [Courses.StudyText?] = []
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        Courses.getTextList { 
            self.textList = Courses.texts
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

extension TheoryClassicsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TextTableViewCell(text: textList[indexPath.row]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        Courses.StudyText.getTextArticle(with: (textList[indexPath.row]?.fileID)!) { 
            let article = Courses.StudyText.textArticle
            
            guard article != nil else {
                MsgDisplay.showErrorMsg("这门课暂时没有详情噢！")
                return
            }
            
            let readingView = TheoryCourseArticleReadingView(article: article!)
            self.navigationController?.view.addSubview(readingView)
            readingView.snp.makeConstraints {
                make in
                make.top.equalTo(self.view)
                make.left.equalTo(self.view)
                make.bottom.equalTo(self.view)
                make.right.equalTo(self.view)
            }

            
        }*/
//        MsgDisplay.showErrorMsg("客户端暂时还不能查看「理论经典」文章详情哦！敬请期待！")
    }
}
