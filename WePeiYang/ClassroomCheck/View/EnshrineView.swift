//
//  EnshrineView.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class EnshrineView: UIView {
    
    let vanishButton = UIButton()
    let enshrineTableView = UITableView(frame: CGRect(x: 45, y: 10, width: 2 * UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height), style: .grouped)
    let cellId = "cell"
    let headerId = "header"
    var timer: Timer!
    var array = [Int]()
    private var classArray = [[[Int]]]()
    private var comps = DateComponents()
    private var courseNum = 0
    private var classroomIDArray: [String]!
    let calendar = Calendar.init(identifier: .gregorian)
    private var mutex = NSLock()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
//        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getTime), userInfo: nil, repeats: true)
        reload()
        setupUI()
        
    }
    @objc func getTime(loc: Int) {
        comps = calendar.dateComponents([.month, .day, .hour, .minute], from: Date())
        if comps.hour! < 8 {
            
        } else if comps.hour! == 9 || (comps.minute! <= 5 && comps.hour! == 10) || (comps.hour! == 8 && comps.minute! >= 30) {
            courseNum = 1
        } else if comps.hour! == 11 || (comps.minute! == 0 && comps.hour! == 12) || (comps.hour! == 10 && comps.minute! >= 25) {
            courseNum = 2
        } else if comps.hour! == 14 || (comps.minute! <= 5 && comps.hour! == 15) || (comps.hour! == 13 && comps.minute! >= 30) {
            courseNum = 3
        } else if comps.hour! == 16 || (comps.minute! <= 0 && comps.hour! == 17) || (comps.hour! == 15 && comps.minute! >= 25) {
            courseNum = 4
        } else if comps.hour! == 19 || (comps.minute! <= 5 && comps.hour! == 20) || (comps.hour! == 18 && comps.minute! >= 30) {
            courseNum = 5
        } else if comps.hour! == 21 || (comps.minute! <= 0 && comps.hour! == 22) || (comps.hour! == 20 && comps.minute! >= 30) {
             courseNum = 6
        } else {
            
        }
        for i in 0..<array.count {
            ClassroomHelper.classroomId = DataHelper.collectionList[i].classroomID
//            ClassHelper.week =
            getClassroomWeekInfo()
//            sleep(10)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                if self.courseNum != 0 {
                    if self.classArray[i][ClassHelper.day - 1][self.courseNum - 1] == 1 {
                        self.array[i] = 1
                    }
                }
            }
            
        }
        
    }
    func getClassroomWeekInfo() {
            ClassroomWeekInfoHelper.getClassroomWeekInfoList(success: { (classroomWeekInfo) in
//                self.classArray = [[[Int]]]()
                var temp = [[Int]]()
                for i in 0..<classroomWeekInfo.data.count {
                    var tArray = [Int]()
                    let data = classroomWeekInfo.data[String(i + 1)]!
                    for j in 1...data.count / 2 {
                        tArray.append(Int(String(data.prefix(2 * j - 1).suffix(1)))!)
                    }
                    temp.append(tArray)
                }
                self.classArray.append(temp)
                
            }) { (_) in
    //            MARK: 起始周要设置好吧，不能是零
    //            如果没选周啥的
//                for _ in 0..<7 {
//                    var array = [Int]()
//                    for _ in 0..<6 {
//                        array.append(0)
//                    }
//                    self.classArray.append(array)
//                }
            }
    }
    func reload() {
        
        CollectionListHelper.getCollectionList(success: { (collectionListData) in
            DataHelper.collectionList = collectionListData
            for i in 0..<collectionListData.count {
                
                ClassroomHelper.classroomId = collectionListData[i].classroomID
                if self.array.count < collectionListData.count {
                    self.array.append(0)
                }
                self.getClassroomWeekInfo()
                
            }
//            MARK: 翻车地
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                for i in 0..<collectionListData.count {
                    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.getTime(loc: )), userInfo: nil, repeats: true)
                }
            }
//            for i in 0..<collectionListData.count {
//                self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.getTime(loc: )), userInfo: nil, repeats: true)
//            }
            
            self.enshrineTableView.reloadData()
        }) { (_) in

        }
        
    }
    
    func setupUI() {
        self.addSubview(enshrineTableView)
        self.addSubview(vanishButton)
        
        vanishButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.equalTo(20)
            make.height.equalTo(vanishButton.snp.width)
        }
        vanishButton.setImage(#imageLiteral(resourceName: "双箭头"), for: .normal)
        
        let headerView = UIView()
        let signView0 = NoticeView()
        let signView1 = NoticeView()
        headerView.addSubview(signView0)
        headerView.addSubview(signView1)
        
        signView0.noticeLabel.text = " 表示空闲"
        signView1.noticeLabel.text = " 表示占用"
        
        signView0.noticeView.layer.cornerRadius = 7.5
        signView0.noticeView.layer.borderWidth = 2
        signView1.noticeView.layer.borderWidth = 2
        signView1.noticeView.layer.borderColor = UIColor.black.cgColor
        signView1.noticeView.layer.cornerRadius = 7.5
        
        signView0.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.right.equalTo(-122)
            make.top.equalTo(10)
        }
        signView1.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            //            make.width.equalToSuperview()
            make.right.equalTo(-122)
            make.top.equalTo(signView0.snp.bottom).offset(10)
        }
        
        enshrineTableView.separatorStyle = .none
        enshrineTableView.backgroundColor = .white
        enshrineTableView.delegate = self
        enshrineTableView.dataSource = self
        enshrineTableView.register(EnshrineTableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension EnshrineView: UITableViewDelegate {
    
}

extension EnshrineView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataHelper.collectionList == nil {
            return 0
        }
        return DataHelper.collectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EnshrineTableViewCell
        cell.locLabel.text = DataHelper.collectionList[indexPath.row].classroom
        cell.idLabel.text = DataHelper.collectionList[indexPath.row].classroomID
//        cell.tag = DataHelper.collectionList[indexPath.row].
        if self.array.count != 0 {
            if self.array[indexPath.row] == 1 {
                cell.circleView.layer.borderColor = UIColor(red: 0.906, green: 0.918, blue: 0.91, alpha: 1).cgColor
            } else {
                cell.circleView.layer.borderColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1).cgColor
            }
        }
        cell.circleView.layer.borderWidth = 2
        cell.selectionStyle = .none
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let signView0 = NoticeView()
        let signView1 = NoticeView()
        headerView.addSubview(signView0)
        headerView.addSubview(signView1)
        
        signView0.noticeLabel.text = "表示空闲"
        signView1.noticeLabel.text = "表示占用"
        
        signView0.noticeView.layer.cornerRadius = 7.5
        signView0.noticeView.layer.borderWidth = 2
        signView1.noticeView.layer.borderWidth = 2
        signView1.noticeView.layer.borderColor = UIColor(red: 0.906, green: 0.918, blue: 0.91, alpha: 1).cgColor
        signView1.noticeView.layer.cornerRadius = 7.5
        
        signView0.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.right.equalToSuperview().offset(-70)
            make.width.equalTo(70)
            make.top.equalTo(10)
        }
        signView1.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            //            make.width.equalToSuperview()
            make.right.equalTo(signView0.snp.right)
            make.width.equalTo(70)
            make.top.equalTo(signView0.snp.bottom).offset(10)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EnshrineTableViewCell
        ClassroomHelper.buildingId = String((cell.locLabel.text?.prefix(3))!)
        
        ClassroomHelper.classroomName = String((cell.locLabel.text?.substring(from: "aaa".endIndex))!)
        ClassroomHelper.classroomId = cell.idLabel.text!
        
        UIViewController.current?.navigationController?.pushViewController(DetailRoomCheckViewController(), animated: true)
    }
    
    
}

