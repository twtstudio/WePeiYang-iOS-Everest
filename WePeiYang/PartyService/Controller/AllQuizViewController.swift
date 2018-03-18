//
//  AllQuizViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/30.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

class AllQuizViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    typealias Quiz = Courses.Study20.Quiz
    let reuseIdentifier = "quizCell"
    var quizList: [Quiz?] = Courses.Study20.courseQuizes
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //NavigationBar 的背景，使用了View
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64 ))
        
        bgView.backgroundColor = .partyRed
        self.view.addSubview(bgView)
        
        //改变 statusBar 颜色
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        navigationController?.navigationBar.barStyle = .black
        let downArrow = UIButton(backgroundImageName: "ic_arrow_down", desiredSize: CGSize(width: 88, height: 24))
        downArrow?.tintColor = UIColor.white
        
        view.addSubview(downArrow!)
        downArrow!.snp.makeConstraints {
            make in
            make.top.equalTo(view).offset(28)
            make.centerX.equalTo(view)
            
        }
        
        downArrow?.addTarget(self, action: #selector(AllQuizViewController.dismissAnimated), for: .touchUpInside)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissAnimated))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        /*
        //titleLabel设置
        let titleLabel = UILabel(text: "所有题目", fontSize: 17)
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .Center
        titleLabel.textColor = .white
        self.navigationItem.titleView = titleLabel;
 */
        
       
        
    }

    @objc func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
    
    convenience init(quizList: [Quiz?]) {
        self.init()
        
        self.quizList = quizList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.makeUICollectionView()
        
    }
    
    func makeUICollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = UICollectionViewScrollDirection.Vertical  //滚动方向
        //layout.itemSize = CGSizeMake(screenWidth/4, 80)
        
        // 设置CollectionView
        let collectionView : UICollectionView = UICollectionView(frame: CGRect(x: 0, y: 64, width: (UIApplication.shared.keyWindow?.frame.size.width)!, height: (UIApplication.shared.keyWindow?.frame.size.height)!-64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(QuizCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.view .addSubview(collectionView)
        
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(quizList.count)
        return quizList.count
    }
    
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! QuizCell
        
        cell.label.text = "\(indexPath.row+1)"
        
        let aQuiz = quizList[indexPath.row]
        cell.imageView.image = aQuiz?.chosenOnesAtIndex == nil ? UIImage(named: "QuizNotDone") : UIImage(named: "QuizDone")
        
        return cell;
        
    }
    //MARK:UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: {
            if let quizTakingVC = UIViewController.current as? QuizTakingViewController {
                //show Quiz View
                quizTakingVC.showQuizAtIndex(at: indexPath.row)
                
            }
        })
    }
    
    //MARK:UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(8, 8, 8, 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/5, height: 80)
    }
    
}
