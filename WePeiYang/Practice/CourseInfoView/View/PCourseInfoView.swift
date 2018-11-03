//
//  PCourseInfoViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/10/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class PCourseInfoView: UIView {
    var courseId: String = ""
    var courseName: String = ""
    var courseInfo: [PCourseInfo] = []
    
    let bkgView = UIView()
    let courseInfoView = PCourseInfoTableView(frame: .zero, style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBkgView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCourseInfo(courseID: String, courseName: String) {
        PCourseInfoNetwork.getCourseInfo(courseId: courseID, success: { (data) in
            self.courseInfo = data
            self.courseName = courseName
            self.setupCourseInfoView()
        }) { (err) in
            log(err)
        }
    }
    
    private func setupBkgView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hindCourseInfo))

        bkgView.frame = window.bounds
        bkgView.addGestureRecognizer(gesture)
        bkgView.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        self.addSubview(bkgView)
    }
    
    private func setupCourseInfoView() {
        let i: CGFloat = CGFloat(courseInfo.count + 2)
        let infoW = 0.8 * deviceWidth
        let infoH: CGFloat = i * 44
        courseInfoView.initTableView(courseName: courseName, courseInfo: courseInfo)
        courseInfoView.frame = CGRect(x: 0.5 * deviceWidth, y: 0.5 * deviceHeight, width: 0, height: 0)
        UIView.animate(withDuration: 0.3) {
            self.courseInfoView.frame = CGRect(x: 0.1 * deviceWidth, y: 0.5 * (deviceHeight - infoH), width: infoW, height: infoH)
        }
        self.addSubview(courseInfoView)
    }

    @objc private func hindCourseInfo() {
        UIView.animate(withDuration: 0.3) {
            self.courseInfoView.frame = CGRect(x: 0.5 * deviceWidth, y: 0.5 * deviceHeight, width: 0, height: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.removeFromSuperview()
            }
        }
    }
}

