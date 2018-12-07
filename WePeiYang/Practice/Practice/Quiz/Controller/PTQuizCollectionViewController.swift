//
//  PTQuizCollectionViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/3.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import PopupDialog

class PTQuizCollectionViewController: UIViewController {
    let questionViewParameters = PTQuestionViewParameters()

    var timer: Timer!
    static var usedTime: String = "00:00"
    static var usrAnsArray: [String] = []
    var quizArray: [PTQuizQuestion] = []
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
    let quesListCollectionView = PTQuesListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let quesListBkgView = UIView()

    let orderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()

    let showBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "questions"), for: .normal)
        return btn
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
        btn.isUserInteractionEnabled = false
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

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor.practiceBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: timeButton)
        let item = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        navigationItem.title = "模拟考试"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        guard let tim = self.timer else { return }
        tim.invalidate()
    }
    
    override func navigationShouldPopMethod() -> Bool {
        let doneNum = getDoneNum()
        let warningCard = PopupDialog(title: "本次测试共\(quizArray.count)题，你已完成\(doneNum)题", message: "交卷后，本次测试记录可在“我的历史”中查看。直接退出将不保存本次做题记录。", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let leftButton = PracticePopupDialogButton(title: "信心满满，交了", dismissOnTap: true) {
            // TODO: 交卷
            self.clearUsrAns()
            self.postResult()
        }
        let midButton = PracticePopupDialogButton(title: "再检查一下", dismissOnTap: true) { return }
        let rightButton = PracticePopupDialogButton(title: "直接退出", dismissOnTap: true) {
            self.clearUsrAns()
            self.navigationController?.popViewController(animated: true)
        }
        rightButton.titleColor = UIColor.practiceRed
        warningCard.addButtons([leftButton, midButton, rightButton])
        self.present(warningCard, animated: true, completion: nil)
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeQues"), object: nil)
    }
}

extension PTQuizCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quizArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ques = quizArray[indexPath.item]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PTQuizQuesCollectionCell
        
        if let content = ques.content, let optionArray = ques.options, let quesType = ques.quesType {
            cell.loadQues(ques: content, options: optionArray, qType: quesType, selectedAns: PTQuizCollectionViewController.usrAnsArray[indexPath.item])
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

//网络请求
extension PTQuizCollectionViewController {
    private func getQuesArray(courseId: String) {
        PTQuizNetWork.getQuizQuesArray(courseId: courseId, success: { (data, tim) in
            self.time = tim
            self.quizArray = data
            for _ in 0..<self.quizArray.count {
                let g = Guard()
                self.guards.append(g)
                PTQuizCollectionViewController.usrAnsArray.append("")
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
            log(err)
        }
    }
    
    @objc private func postResult() {
        var dicArray: [[String: String]] = []
        for i in 0..<quizArray.count {
            var dic: [String: String] = [:]
            guard let quesId = quizArray[i].id else { return }
            guard let quesType = quizArray[i].quesType else { return }
            dic["id"] = String(quesId)
            if let ans = guards[i].answer {
                dic["answer"] = ans
            } else {
                dic["answer"] = ""
            }
            dic["type"] = String(quesType)
            dicArray.append(dic)
        }

        let result = try? dicArray.jsonString()
        guard let resultdata = result else { return }
        guard let resultData = resultdata else { return }
        let dic = ["result": resultData,
                   "course_id": courseId,
                   "time": String(time)]
        
        PTQuizNetWork.postQuizResult(dics: dic, courseId: courseId, time: time) { (data) in
            self.turnToResultVc()
            PracticeResultViewController.pQuizResult = data
        }
    }
}

//MARK: objc func
extension PTQuizCollectionViewController {
    @objc private func tickDown() {
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
    
    @objc private func postBtnTapped(_ button: UIButton) {
        let doneNum = getDoneNum()
        let warningCard = PopupDialog(title: "本次测试共\(quizArray.count)题，你已完成\(doneNum)题", message: "提交后答案将不可更改", buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        let leftButton = PracticePopupDialogButton(title: "信心满满，交卷了", dismissOnTap: true) {
            //TODO: 交卷
            self.clearUsrAns()
            self.postResult()
        }
        let rightButton = PracticePopupDialogButton(title: "再检查一下", dismissOnTap: true) {
            // TODO: 进入模拟考试
            warningCard.dismiss()
        }
        rightButton.titleColor = UIColor.practiceRed
        warningCard.addButtons([leftButton, rightButton])
        hindQuesList()
        self.present(warningCard, animated: true, completion: nil)
    }
    
    @objc private func updateAnswer() {
        // 储存答案String
        let startValue = Int(("A" as UnicodeScalar).value)
        var answerString = ""
        for i in 0..<PTQuestionTableView.selectedAnswerArray.count {
            if PTQuestionTableView.selectedAnswerArray[i] {
                let string = String(UnicodeScalar(i + startValue)!)
                answerString = answerString + string
            }
        }
        PTQuizCollectionViewController.usrAnsArray[currentPage - 1] = answerString
        guards[currentPage - 1].answer = answerString
        if answerString != "" {
            guards[currentPage - 1].iscorrect = .right
        } else {
            guards[currentPage - 1].iscorrect = .unknown
        }
    }
    
    // 通过列表切换题目
    @objc private func changeQues() {
        currentPage = PTQuesListCollectionView.chosenPage
        collectionView.contentOffset.x = CGFloat(currentPage - 1) * deviceWidth
        for i in 0..<quizArray.count {
            isSelected.append(guards[i].iscorrect)
        }
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: quizArray.count, isCorrect: isSelected)
        quesListCollectionView.reloadData()
        setupButtons()
    }
    
    // 收藏按钮点击事件
    @objc private func collect(_ button: UIButton) {
        let ques = quizArray[1]
        guard let qType = ques.quesType else { return }
        guard let qID = ques.id else { return }
        if guards[currentPage - 1].iscollected {
            guards[currentPage - 1].iscollected = false
            button.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            PracticeCollectionHelper.deleteCollection(quesType: String(qType), quesID: String(qID))
        } else {
            guards[currentPage - 1].iscollected = true
            button.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
            PracticeCollectionHelper.addCollection(quesType: String(qType), quesID: String(qID))
        }
    }
    
    // 显示题号列表
    @objc private func showQuesCollectionView(_ button: UIButton) {
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
        listPostButton.addTarget(self, action: #selector(postBtnTapped(_:)), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.3) {
            self.quesListCollectionView.frame = CGRect(x: 0, y: 0.48 * deviceHeight, width: deviceWidth, height: 0.45 * deviceHeight)
            self.listPostButton.frame = CGRect(x: 0, y: 0.92 * deviceHeight, width: deviceWidth, height: 0.08 * deviceHeight)
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hindQuesList))
        quesListBkgView.addGestureRecognizer(gesture)
    }
    
    @objc private func hindQuesList() {
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

//MARK: 界面初始化、基本控件加载
extension PTQuizCollectionViewController {
    private func turnToResultVc() {
        let min: Int = 24 - restTime / 60
        let sec: Int = 60 - restTime % 60
        if sec < 10 {
            PTQuizCollectionViewController.usedTime = "\(min):0\(sec)"
        }
        PTQuizCollectionViewController.usedTime = "\(min):0\(sec)"
        PracticeResultViewController.ishistory = false
        let resultVC = PracticeResultViewController()
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    private func loadData() {
        getQuesArray(courseId: courseId)
    }
    
    private func initcollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.contentSize = CGSize(width: deviceWidth * 3, height: deviceHeight)
        collectionView.isPagingEnabled = true
        collectionView.register(PTQuizQuesCollectionCell.self, forCellWithReuseIdentifier: "collectionCell")
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
    
    private func setPostBtn() {
        self.view.addSubview(postButton)
        postButton.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalTo(self.view)
            make.height.equalTo(0.07 * deviceHeight)
        }
    }
    
    private func setupButtons() {
        let offset = 0.05 * deviceWidth
        let buttonsViewW = questionViewParameters.questionViewW
        let buttonsViewH = 0.05 * deviceHeight
        
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
    
    private func setupSaperator() {
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
    
    private func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
    }
    
    private func getDoneNum() -> Int {
        var doneNum: Int = 0
        for i in guards where i.iscorrect == .right {
            doneNum += 1
        }
        return doneNum
    }
    
    private func clearUsrAns() {
        PTQuizCollectionViewController.usrAnsArray = []
    }
}
