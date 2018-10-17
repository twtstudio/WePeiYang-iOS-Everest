//
//  QuizCollectionViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/3.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import PopupDialog

class QuizCollectionViewController: UIViewController {
    let questionViewParameters = QuestionViewParameters()

    var timer: Timer!
    static var usrAnsArray: [String] = []
    var quizArray: [QuizQuestion] = []
    var guards: [Guard] = []
    var isSelected: [isCorrect] = []
    var scrollDirection: Direction = .none
    
    var time: Int = {
        return 0
    }()
    
    var count: Int = {
        return 0
    }()

    var isinited: Int = {
        return 0
    }()
    
    var courseId: String = {
        return PracticeFigure.courseID
    }()
    
    var currentPage : Int = {
        return 1
    }()
    
    var lastoffset: CGFloat = {
        return deviceWidth
    }()
    
    var currentoffset: CGFloat = {
        return 0
    }()
    
    var indexArray: [Int] = []
    
    let totalTime: Int = {
        return 25 * 60
    }()
    
    var restTime: Int = {
        return 25 * 60
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let quesListCollectionView = QLCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let quesListBkgView = UIView()

    let orderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()

    let collectBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
        return btn
    }()
    
    let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let timeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("25:00", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.width =  0.2 * deviceWidth
        btn.height = 0.08 * deviceWidth
        return btn
    }()
    
    let postButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("提交答案", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.practiceBlue
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(postBtnTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    let listPostButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("提交答案", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.practiceBlue
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(postBtnTapped(_:)), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initcollectionView()
        setupSaperator()
        initTimer()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAnswer), name: NSNotification.Name(rawValue: "QuizOptionSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeQues), name: NSNotification.Name(rawValue: "changeQues"), object: nil)
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor.practiceBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "模拟考试"
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: timeButton)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let tim = self.timer else { return }
        tim.invalidate()
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
            cell.loadQues(ques: content, options: optionArray, qType: quesType, selectedAns: QuizCollectionViewController.usrAnsArray[indexPath.item])
            cell.questionView.reloadData()
        } else {
            cell.loadQues(ques: "oops, no data", options: ["oops, no data", "oops, no data", "oops, no data", "oops, no data"], qType: 0, selectedAns: "")
        }
        cell.initQuizCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: deviceWidth, height: deviceHeight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 刷新页面计数
        currentPage = Int(scrollView.contentOffset.x / deviceWidth) + 1
        if currentPage < 1 {
            currentPage = 1
        }
        scrollDirection = .none

        // 刷新button
        setupButtons()
    }
}

extension QuizCollectionViewController: UINavigationBarDelegate {
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        var shouldPop = true
        let warningCard = PopupDialog(title: "确认退出？", message: "退出后此次检测将没有成绩", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let leftButton = PracticePopupDialogButton(title: "确认", dismissOnTap: true) {
            // TODO: 继续退出
            shouldPop = true
        }
        let rightButton = PracticePopupDialogButton(title: "取消", dismissOnTap: true) {
            // TODO: 不退出
            shouldPop = false
        }
        rightButton.titleColor = UIColor.practiceRed
        warningCard.addButtons([leftButton, rightButton])
        self.present(warningCard, animated: true, completion: nil)
        return shouldPop
    }
}

//网络请求
extension QuizCollectionViewController {
    fileprivate func getQuesArray(courseId: String) {
        QuizNetWork.getQuizQuesArray(courseId: courseId, success: { (data, tim) in
            self.time = tim
            self.quizArray = data
            for _ in 0..<self.quizArray.count {
                let g = Guard()
                self.guards.append(g)
                QuizCollectionViewController.usrAnsArray.append("")
            }
            self.setupButtons()
            if self.isinited == 0 {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.isinited = 1
            } else {
                self.collectionView.reloadData()
            }
        }) { (err) in
            debugLog(err)
        }
    }
    
    @objc func postResult() {
        var dicArray: [[String: Any]] = []
        for i in 0..<quizArray.count {
            var dic: [String: Any] = [:]
            dic["id"] = quizArray[i].id
            if let ans = guards[i].answer {
                dic["answer"] = ans
            } else {
                dic["answer"] = ""
            }
            dic["type"] = quizArray[i].quesType
            dicArray.append(dic)
        }
        let dic = ["data": dicArray]
        QuizNetWork.postQuizResult(dics: dic, courseId: courseId, time: time) { (dic) in
            // TODO: 提交答案之后应该跳转页面
            
        }
    }
}


//界面初始化、基本控件加载、点击事件
extension QuizCollectionViewController {
    func loadData() {
        getQuesArray(courseId: courseId)
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
        collectionView.register(QuizQuesCollectionCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.width.equalTo(deviceWidth)
            make.height.equalTo(deviceHeight)
            make.center.equalTo(view)
        }
    }
    
    func setPostBtn() {
        self.view.addSubview(postButton)
        postButton.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalTo(self.view)
            make.height.equalTo(0.07 * deviceHeight)
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
        
        // 如果在最后一页，就要加上提交到button。否则移去
        if currentPage == quizArray.count {
            setPostBtn()
        } else {
            postButton.removeFromSuperview()
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
    
    @objc func tickDown() {
        if restTime == 0 {
            //TODO: 检测模式做题时间到，跳转至下一页面
            guard let tim = self.timer else { return }
            tim.invalidate()
            
            // 规定时间到
            let warningCard = PopupDialog(title: "时间到！", message: "检测时间到，必须交卷了哦", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
            let button = PracticePopupDialogButton(title: "确认", dismissOnTap: true) {
                self.postResult()
            }
            button.titleColor = UIColor.practiceRed
            warningCard.addButtons([button])
            self.present(warningCard, animated: true, completion: nil)
            return
        }
        restTime -= 1
        let min: Int = restTime / 60
        let sec: Int = restTime % 60
        if sec < 10 {
            timeButton.setTitle("\(min):0\(sec)", for: .normal)
        }
        timeButton.titleLabel?.text = "\(min):\(sec)"
    }
    
    @objc func postBtnTapped(_ button: UIButton) {
        let warningCard = PopupDialog(title: "确认提交？", message: "提交后答案将不可更改", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let leftButton = PracticePopupDialogButton(title: "信心满满，交卷了", dismissOnTap: true) {
            self.postResult()
        }
        let rightButton = PracticePopupDialogButton(title: "再检查一下", dismissOnTap: true) {
            // TODO: 进入模拟考试
            warningCard.dismiss()
        }
        rightButton.titleColor = UIColor.practiceRed
        warningCard.addButtons([leftButton, rightButton])
        self.present(warningCard, animated: true, completion: nil)
    }
    
    @objc func updateAnswer() {
        //储存答案String
        let startValue = Int(("A" as UnicodeScalar).value)
        var answerString = ""
        for i in 0..<QuestionTableView.selectedAnswerArray.count {
            if QuestionTableView.selectedAnswerArray[i] {
                let string = String(UnicodeScalar(i + startValue)!)
                answerString = answerString + string
            }
        }
        QuizCollectionViewController.usrAnsArray[currentPage - 1] = answerString

        if answerString != "" {
            guards[currentPage - 1].iscorrect = .right
        }
    }
    
    // 通过列表切换题目
    @objc func changeQues() {
        currentPage = QLCollectionView.chosenPage
        collectionView.contentOffset.x = CGFloat(currentPage - 1) * deviceWidth
        for i in 0..<quizArray.count {
            isSelected.append(guards[i].iscorrect)
        }
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: quizArray.count, isCorrect: isSelected)
        quesListCollectionView.reloadData()
        setupButtons()
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
                debugLog(err)
            }) { (dic) in
                //TODO: 收藏后动作
            }
        }else {
            guards[currentPage - 1].iscollected = true
            button.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
            let ques = quizArray[1]
            let data: Dictionary<String, Any> = ["tid": 0,
                                                 "ques_type": ques.quesType!,
                                                 "ques_id": ques.id!]
            ExerciseNetwork.deleteCollection(data: data, failure: { (err) in
                debugLog(err)
            }) { (dic) in
                //TODO: 取消收藏后动作
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
        
        isSelected = []
        for i in 0..<pageNum {
            isSelected.append(guards[i].iscorrect)
        }
        
        quesListCollectionView.contentSize = CGSize(width: deviceWidth - 20, height: 0.45 * deviceHeight)
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: pageNum, isCorrect: isSelected)
        quesListCollectionView.reloadData()
        window.addSubview(quesListCollectionView)
        window.addSubview(listPostButton)
        quesListCollectionView.frame = CGRect(x: 0, y: deviceHeight + 30, width: deviceWidth, height: 0.45 * deviceHeight)
        listPostButton.frame = CGRect(x: 0, y: 1.45 * deviceHeight + 30, width: deviceWidth, height: 0.08 * deviceHeight)

        UIView.animate(withDuration: 0.3) {
            self.quesListCollectionView.frame = CGRect(x: 0, y: 0.48 * deviceHeight, width: deviceWidth, height: 0.45 * deviceHeight)
            self.listPostButton.frame = CGRect(x: 0, y: 0.92 * deviceHeight, width: deviceWidth, height: 0.08 * deviceHeight)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hindQuesList))
        quesListBkgView.addGestureRecognizer(gesture)
    }
    
    @objc func hindQuesList() {
        UIView.animate(withDuration: 0.3) {
            // 尾随闭包播放弹出动画
            self.quesListCollectionView.frame = CGRect(x: 0, y: deviceHeight + 30, width: deviceWidth, height: 0.45 * deviceHeight)
            self.listPostButton.frame = CGRect(x: 0, y: 1.45 * deviceHeight + 30, width: deviceWidth, height: 0.08 * deviceHeight)
            // 提交一个延时任务线程
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.quesListCollectionView.removeFromSuperview()
                self.quesListBkgView.removeFromSuperview()
                self.listPostButton.removeFromSuperview()
            }
        }
    }
}





