//
//  QuizCollectionViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/3.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class QuizCollectionViewController: UIViewController {
    let questionViewParameters = QuestionViewParameters()
    
    var isExercising: Bool = true
    
    static var questions: [Question] = []
    var quizArray: [QuizQuestion] = []
    var guards: [Guard] = []
    var isSelected: [isCorrect] = []
    var count = 0
    var isinited = 0
    
    var courseId = Int(PracticeFigure.courseID)!
    
    var currentPage = 1
    var lastoffset: CGFloat = deviceWidth
    var currentoffset: CGFloat = 0
    var indexArray: [Int] = []
    
    let orderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let result: String? = "正确"
    let rightAnswer: String? = "A"
    
    let quesListBkgView = UIView()
    let collectBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
        return btn
    }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let quesListCollectionView = QLCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initcollectionView()
        setupSaperator()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAnswer), name: NSNotification.Name(rawValue: "QuizOptionSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeQues), name: NSNotification.Name(rawValue: "changeQues"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barTintColor = UIColor.practiceBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "模拟考试"
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeQues"), object: nil)
    }
    
    
}

extension QuizCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ques = quizArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! QuizQuesCollectionCell
        
        if let content = ques.content, let optionArray = ques.options, let quesType = ques.quesType {
            cell.loadQues(ques: content, options: optionArray, selected: false, rightAns: "Z", qType: quesType)
            cell.questionView.reloadData()
        }else {
            cell.loadQues(ques: "oops, no data", options: ["oops, no data", "oops, no data", "oops, no data", "oops, no data"], selected: guards[currentPage - 1].selected, rightAns: "no data", qType: 0)
        }
        cell.initQuizCell()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: deviceWidth, height: deviceHeight)
    }
}

//网络请求
extension QuizCollectionViewController {
    fileprivate func getQuesArray(courseId: Int) {
        QuizNetWork.getQuizQuesArray(courseId: courseId, success: { (data) in
            print(data)
            self.quizArray = data
            print(self.quizArray.count)
            if self.isinited == 0 {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.isinited = 1
            } else {
                self.collectionView.reloadData()
            }
        }) { (err) in
            print(err)
        }
    }
    
}


//界面初始化、基本控件加载、点击事件
extension QuizCollectionViewController {
    
    func loadData() {
        getQuesArray(courseId: courseId)
        setupButtons()
    }
    
    func initcollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.contentSize = CGSize(width: deviceWidth * 3, height: deviceHeight)
        collectionView.isPagingEnabled = true
        collectionView.register(ExerciseCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.contentOffset.x = deviceWidth
        collectionView.showsHorizontalScrollIndicator = true
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.width.equalTo(deviceWidth)
            make.height.equalTo(deviceHeight)
            make.center.equalTo(view)
        }
    }
    
    func setupButtons() {
        let offset = 0.05 * deviceWidth
        let buttonsViewW = questionViewParameters.questionViewW
        let buttonsViewH = 0.05 * deviceHeight
        
        let showBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "questions"), for: .normal)
            return btn
        }()
        
        collectBtn.addTarget(self, action: #selector(collect(_:)), for: .touchUpInside)
        showBtn.addTarget(self, action: #selector(showQuesCollectionView(_:)), for: .touchUpInside)
        
        let offsetY = 0.2 * deviceHeight
        let offsetm = 0.004 * deviceHeight
        
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) in
            make.width.equalTo(buttonsViewW)
            make.height.equalTo(buttonsViewH)
            make.centerY.equalTo(view).offset(offsetY)
            make.centerX.equalTo(view)
        }

        orderLabel.textAlignment = .center
        orderLabel.text = "\(currentPage)/\(quizArray.count)"
        buttonsView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.width.equalTo(2.2 * buttonsViewH)
            make.height.equalTo(buttonsViewH)
            make.left.equalTo(buttonsView)
            make.centerY.equalTo(buttonsView).offset(offsetm)
        }
        
        // showBtn和collectBtn 的 make.right.equalTo()无效。很迷。
        buttonsView.addSubview(showBtn)
        showBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(buttonsViewH)
            make.top.equalTo(buttonsView).offset(offsetm)
            make.right.top.equalTo(buttonsView)
        }
        
        buttonsView.addSubview(collectBtn)
        collectBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(buttonsViewH)
            make.top.equalTo(buttonsView).offset(offsetm)
            make.left.equalTo(showBtn).offset(-(offset + buttonsViewH))
        }
        
    }
    
    func setupSaperator() {
        let saperatorW = 0.9 * deviceWidth
        let saperatorView = UIView()
        saperatorView.backgroundColor = UIColor(red: 177/255, green: 196/255, blue: 222/255, alpha: 1)
        view.addSubview(saperatorView)
        saperatorView.snp.makeConstraints { (make) in
            make.width.equalTo(saperatorW)
            make.height.equalTo(1)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(0.24 * deviceHeight)
        }
    }
    
    @objc func updateAnswer() {
        guards[currentPage - 1].selected = true
        guards[currentPage - 1].answer = QuestionTableView.selectedAnswer

        QuestionTableView.selectedAnswer = nil
    }
    
    @objc func changeQues() {
        currentPage = QLCollectionView.chosenPage
//        updateData()
    }
    
    //收藏
    @objc func collect(_ button: UIButton) {
        if guards[currentPage - 1].iscollected {
            guards[currentPage - 1].iscollected = false
            button.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            
            let ques = quizArray[1]
            let data: Dictionary<String, Any> = ["tid": 0,
                                                 "ques_type": ques.quesType!,
                                                 "ques_id": ques.id!]
            ExerciseNetwork.addCollection(data: data, failure: { (err) in
                print(err)
            }) { (dic) in
                //收藏后动作
                print("收藏成功")
            }
        }else {
            guards[currentPage - 1].iscollected = true
            button.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
            let ques = quizArray[1]
            let data: Dictionary<String, Any> = ["tid": 0,
                                                 "ques_type": ques.quesType!,
                                                 "ques_id": ques.id!]
            ExerciseNetwork.deleteCollection(data: data, failure: { (err) in
                print(err)
            }) { (dic) in
                //取消收藏后动作
                print("已取消收藏")
            }
        }
    }
    
    //显示题号列表
    
    @objc func showQuesCollectionView(_ button: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        quesListBkgView.frame = window.bounds
        quesListBkgView.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        window.addSubview(quesListBkgView)
        let pageNum = quizArray.count
//        isCorrected = []
//        for i in 0..<pageNum {
//            isCorrected.append(guards[i].iscorrect)
//        }
        quesListCollectionView.contentSize = CGSize(width: deviceWidth - 20, height: 0.45 * deviceHeight)
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: pageNum, isCorrect: isSelected)
        quesListCollectionView.reloadData()
        window.addSubview(quesListCollectionView)
        quesListCollectionView.frame = CGRect(x: 0, y: deviceHeight + 30, width: deviceWidth, height: 0.45 * deviceHeight)
        UIView.animate(withDuration: 0.3) {
            self.quesListCollectionView.frame = CGRect(x: 0, y: 0.55 * deviceHeight, width: deviceWidth, height: 0.45 * deviceHeight)
        }
    
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hindQuesList))
        quesListBkgView.addGestureRecognizer(gesture)
    }
    
    @objc func hindQuesList() {
        UIView.animate(withDuration: 0.3) {
            // 尾随闭包播放弹出动画
            self.quesListCollectionView.frame = CGRect(x: 0, y: deviceHeight + 30, width: deviceWidth, height: 0.45 * deviceHeight)
            
            // 提交一个延时任务线程
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.quesListCollectionView.removeFromSuperview()
                self.quesListBkgView.removeFromSuperview()
            }
        }
    }
}





