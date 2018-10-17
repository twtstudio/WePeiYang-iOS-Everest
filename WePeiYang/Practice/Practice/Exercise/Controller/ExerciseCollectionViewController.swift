//
//  PracticeCollectionView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/23.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class ExerciseCollectionViewController: UIViewController {    
    let questionViewParameters = QuestionViewParameters()

    var isExercising: Bool = true

    static var questions: [Question] = []
    var questionArray: [Question] = []
//    var answers: [Answer] = []
    var guards: [Guard] = []
    var idList: [Int?] = []
    var isCorrected: [isCorrect] = []
    var count = 0
    var isinited = 0
    
    var scrollDirection: Direction = .none
    var mode: ExerciseMode = .exercise
    
//    var classId = Int(PracticeFigure.classID)!
//    var courseId = Int(PracticeFigure.courseID)!
//    var quesType = Int(PracticeFigure.questionType)!
    var classId = 2
    var courseId = 2
    var quesType = 0

    var currentPage = 1
    var currentIndex = 0
    var lastoffset: CGFloat = deviceWidth
    var currentoffset: CGFloat = 0
    var indexArray: [Int] = []
    var usrMultipleAnser: [String] = []
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let quesListCollectionView = QLCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let quesListBkgView = UIView()
    
    let orderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let result: String? = "正确"
    let rightAnswer: String? = "A"
    
    let collectBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
        return btn
    }()
    
    let checkBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.practiceBlue
        btn.setTitle("确认答案", for: .normal)
        return btn
    }()
    
    let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initcollectionView()
        setupSaperator()
        getIdList(courseId: courseId, quesType: quesType)

        NotificationCenter.default.addObserver(self, selector: #selector(updateAnswer), name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeQues), name: NSNotification.Name(rawValue: "changeQues"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        //答题、背题切换
        let items = ["背题", "答题"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor = UIColor.white
        segmentedControl.backgroundColor = .clear
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(changeMode(_:)   ), for: .valueChanged)
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.cornerRadius = 12
        segmentedControl.clipsToBounds = true
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor.practiceBlue
        navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = UIView(frame: CGRect(x: 0, y: 0, width: 0.3 * deviceWidth, height: 24))
        navigationItem.titleView?.backgroundColor = .clear
        navigationItem.titleView?.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.center.equalTo(navigationItem.titleView!)
            make.width.equalTo(navigationItem.titleView!)
            make.height.equalTo(navigationItem.titleView!)
        }
    }
    
    @objc func changeMode(_ segmented: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0:
            mode = .memorize
            collectionView.reloadData()
        case 1:
            mode = .exercise
            collectionView.reloadData()
        default:
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeQues"), object: nil)
    }
}

extension ExerciseCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ques = questionArray[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ExerciseCell

        if let content = ques.quesDetail?.content, let optionArray = ques.quesDetail?.option, let correctAns = ques.quesDetail?.correctAnswer, let quesType = ques.quesDetail?.type {
            cell.loadQues(answer: usrMultipleAnser[indexArray[indexPath.item]], ques: content, options: optionArray, selected: guards[indexArray[indexPath.item]].selected, rightAns: correctAns, qType: quesType)
            cell.questionView.reloadData()
        } else {
            cell.loadQues(answer: "none", ques: "oops, no data", options: ["oops, no data", "oops, no data", "oops, no data", "oops, no data"], selected: guards[currentPage - 1].selected, rightAns: "no data", qType: 0)
        }
        cell.initExerciseCell()

        //如果之前查看了答案要把answerView加上去
        if mode == .memorize {
            cell.addAnswerView(result: guards[indexArray[indexPath.item]].answer, rightAnswer: ques.quesDetail?.correctAnswer)
        } else {
            if guards[indexArray[indexPath.item]].ischecked {
                cell.addAnswerView(result: guards[indexArray[indexPath.item]].answer, rightAnswer: ques.quesDetail?.correctAnswer)
            } else {
                cell.removeAnswerView()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: deviceWidth, height: deviceHeight)
    }
}

//网络请求
extension ExerciseCollectionViewController {
    private func getIdList(courseId: Int, quesType: Int) {
        //这里会先运行 PracticeNetwork.getIdList
        var idList: [Int?] = []
        ExerciseNetwork.getIdList(courseId: courseId, quesType: quesType, success: { (idArray) in
            idList = idArray
            self.indexArray = [idList.count - 1, 0, 1]
            for _ in 0..<idList.count {
                let guarding = Guard()
                self.guards.append(guarding)
                self.usrMultipleAnser.append("")
            }
            self.idList = idList
            self.loadData()
        }) { (err) in
            print(err)
        }
    }
    
    private func getQues(id: Int) {
        ExerciseNetwork.getQues(courseId: courseId, quesType: quesType, id: id, success: { (ques) in
            self.count = self.count + 1
            
            if self.count == 3 && ExerciseCollectionViewController.questions.count == 3{
                self.count = 0
                var qs: [Question] = []
                
                // 调整题目顺序，因为返回题目的顺序和网速有关，不是先请求的题目就一定先返回。所以返回的数组大部分为乱序。
                for i in 0..<3 {
                    for j in 0..<3 {
                        let ques = ExerciseCollectionViewController.questions[j]
                        if ques.quesDetail!.id == self.idList[self.indexArray[i]] {
                            qs.append(ques)
                        }
                    }
                }
                
                for i in 0..<3 {
                    switch qs[i].quesDetail?.isCollected {
                    case 0?:
                        self.guards[self.indexArray[i]].iscollected = false
                    case 1?:
                        self.guards[self.indexArray[i]].iscollected = true
                    default:
                        break
                    }
                    
                    switch qs[i].quesDetail?.isMistake {
                    case 0?:
                        self.guards[self.indexArray[i]].isMistake = false
                    case 1?:
                        self.guards[self.indexArray[i]].isMistake = true
                    default:
                        break
                    }
                }
                self.questionArray = qs

                if self.isinited == 0 {
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.isinited = 1
                } else {
                    self.reloadQuesCollectionView(scrollDirection: self.scrollDirection)
                }
            }else if self.count == 3 {
                self.count = 0
                self.updateData()
            }
            
        }) { (err) in
            print(err)
        }
    }
    
    private func reloadQuesCollectionView(scrollDirection: Direction) {
        var array: [IndexPath] = []
        var reloadRange = 0...2
        
        switch scrollDirection {
        case .left:
            reloadRange = 0...1
        case .right:
            reloadRange = 1...2
        default:
            self.collectionView.reloadData()
            return
        }

        for i in reloadRange {
            let indexPath = IndexPath(item: i, section: 0)
            array.append(indexPath)
        }
        self.collectionView.reloadItems(at: array)
    }
    
    private func getQuesArray() {
        ExerciseCollectionViewController.questions = []
        for index in indexArray {
            if let id = idList[index] {
                getQues(id: id)
            }else {
                let questionDetail = QuestionDetails(id: nil, classId: nil, courseId: nil, type: nil, content: nil, option: nil, correctAnswer: nil, isCollected: nil, isMistake: nil)
                
                let question = Question(status: nil, quesDetail: questionDetail)
                ExerciseCollectionViewController.questions.append(question)
            }
        }
    }
}

// MARK: 页面切换
extension ExerciseCollectionViewController {
    private func updateData() {
        // 页面记录更新
        let lastIndex = (currentIndex - 1) == -1 ? idList.count - 1 : (currentIndex - 1)
        let nextIndex = (currentIndex + 1) == idList.count ? 0 : (currentIndex + 1)
        indexArray = [lastIndex, currentIndex, nextIndex]
        
        SolaSessionManager.cancelAllTask()
        getQuesArray()
        orderLabel.text = "\(currentPage)/\(idList.count)"
        
        // 判断是否收藏
        if guards[currentIndex].iscollected {
            collectBtn.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
        }else {
            collectBtn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
        }

        if quesType == 1 {
            if guards[currentIndex].ischecked {
                checkBtn.removeFromSuperview()
            } else {
                setCheckBtn()
            }
        }
        
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: idList.count, isCorrect: isCorrected)
        quesListCollectionView.reloadData()
    }

    /// 判断滑动方向
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 页面滑动距离大于等于 设备屏幕宽度 时确认为滑动
        currentoffset = scrollView.contentOffset.x
        let offset = lastoffset - currentoffset
        if offset >= deviceWidth {
            scrollDirection = .right
        } else if offset <= -deviceWidth {
            scrollDirection = .left
        }
        
        var reloadItem: Int = 0
        switch scrollDirection {
        // 左滑，滑向下一题
        case .left:
            currentPage = (currentPage + 1) == idList.count + 1 ? 1 : (currentPage + 1)
            currentIndex = currentPage - 1
            updateData()
            reloadItem = 2
            
        // 右滑，滑向上一题
        case .right:
            currentPage = (currentPage - 1) == 0 ? idList.count : (currentPage - 1)
            currentIndex = currentPage - 1
            updateData()
            reloadItem = 0
        default:
            return
        }

        /// 因为是用3个cell循环实现的题目切换，因此网络请求时差和页面瞬间切换会导致画面闪动问题
        /// 解决方法，滑动到新界面后，先刷新另外两个不显示的cell，再切换页面，最后刷新最后一个（此时也已经不显示了）cell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            scrollView.contentOffset.x = deviceWidth
        }
        let indexPath = IndexPath(item: reloadItem, section: 0)
        let array = [indexPath]
        self.collectionView.reloadItems(at: array)
        print("Last Cell RELOADED")
        scrollDirection = .none
    }
    
}

//界面初始化、基本控件加载、点击事件
extension ExerciseCollectionViewController {
    
    private func loadData() {
        getQuesArray()
        setupButtons()
    }
    
    /// 底部CollectionView基本属性设置
    private func initcollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.contentSize = CGSize(width: deviceWidth * 3, height: deviceHeight)
        collectionView.isPagingEnabled = true
        collectionView.register(ExerciseCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.showsHorizontalScrollIndicator = false
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

    private func setupButtons() {
        let offset = 0.05 * deviceWidth
        let buttonsViewW = questionViewParameters.questionViewW
        let buttonsViewH = 0.05 * deviceHeight
        
        let showBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "questions"), for: .normal)
            return btn
        }()
        
        checkBtn.setTitleColor(.white, for: .normal)
        checkBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        checkBtn.layer.cornerRadius = 0.1 * buttonsViewH
        checkBtn.layer.borderWidth = 1
        checkBtn.layer.borderColor = UIColor.practiceBlue.cgColor
        
        collectBtn.addTarget(self, action: #selector(collect(_:)), for: .touchUpInside)
        checkBtn.addTarget(self, action: #selector(checkBtnTapped(_:)), for: .touchUpInside)
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
        
        if quesType == 1 {
            setCheckBtn()
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
        
        orderLabel.textAlignment = .center
        orderLabel.text = "\(currentPage) / \(idList.count)"
        buttonsView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.width.equalTo(2.2 * buttonsViewH)
            make.height.equalTo(buttonsViewH)
            make.right.equalTo(collectBtn).offset(-(offsetm + buttonsViewH))
            make.centerY.equalTo(buttonsView).offset(offsetm)
        }
        
        
    }

    private func setCheckBtn() {
        let buttonsViewH = 0.05 * deviceHeight
        let offsetm = 0.004 * deviceHeight
        buttonsView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(0.8 * buttonsViewH)
            make.left.equalTo(buttonsView)
            make.centerY.equalTo(buttonsView).offset(offsetm)
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
    
    func answerupdate(selectedAns: String) {
        for _ in 0..<30 {
            let guarding = Guard()
            self.guards.append(guarding)
        }
    }

    private func check() {
        guards[currentIndex].ischecked = true
        
        if guards[currentIndex].selected {
            let indexPath = IndexPath(item: 1, section: 0)
            self.collectionView.reloadItems(at: [indexPath])
//            QuestionTableView.selectedAnswer = nil
            return
        }
    }
    
    @objc private func updateAnswer() {
        guards[currentIndex].selected = true
        guards[currentIndex].answer = QuestionTableView.selectedAnswer
        guard let usrAns = QuestionTableView.selectedAnswer else { return }
        usrMultipleAnser[currentIndex] = usrAns
        
        guard let answer = guards[currentIndex].answer else { return }
        if answer == questionArray[1].quesDetail!.correctAnswer {
            guards[currentIndex].iscorrect = .right
        } else {
            guards[currentIndex].iscorrect = .wrong
            
            let mistakeQuesData: Dictionary<String, Any> = ["tid": 1,
                                                            "ques_id": questionArray[1].quesDetail?.id ?? 0,
                                                            "ques_type": questionArray[1].quesDetail?.type ?? 3,
                                                            "error_option": answer]
            ExerciseNetwork.postMistakeQues(courseId: courseId, data: mistakeQuesData, failure: { (err) in
                print(err)
            }) { (dic) in
                //                    print(dic)
            }
        }
        
        check()
        QuestionTableView.selectedAnswer = nil
    }
    
    @objc private func changeQues() {
        currentPage = QLCollectionView.chosenPage
        currentIndex = currentPage - 1
        updateData()
    }
    
    //收藏
    @objc private func collect(_ button: UIButton) {
        if guards[currentIndex].iscollected {
            guards[currentIndex].iscollected = false
            button.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            
            let ques = questionArray[1].quesDetail!
            let data: Dictionary<String, Any> = ["tid": 0,
                                                 "ques_type": ques.type!,
                                                 "ques_id": ques.id!]
            ExerciseNetwork.addCollection(data: data, failure: { (err) in
                print(err)
            }) { (dic) in
                //收藏后动作
                print("收藏成功")
            }
        } else {
            guards[currentIndex].iscollected = true
            button.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
            let ques = questionArray[1].quesDetail!
            let data: Dictionary<String, Any> = ["tid": 0,
                                                 "ques_type": ques.type!,
                                                 "ques_id": ques.id!]
            ExerciseNetwork.deleteCollection(data: data, failure: { (err) in
                print(err)
            }) { (dic) in
                //取消收藏后动作
                print("已取消收藏")
            }
        }
    }
    
    //
    @objc private func checkBtnTapped(_ button: UIButton) {
        guards[currentIndex].selected = true
        guards[currentIndex].ischecked = true
        button.removeFromSuperview()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Check Multiple Choice Answer"), object: nil)
        //储存答案String
        let startValue = Int(("A" as UnicodeScalar).value)
        var answerString = ""
        for i in 0..<QuestionTableView.selectedAnswerArray.count where QuestionTableView.selectedAnswerArray[i] {
            let string = String(UnicodeScalar(i + startValue)!)
            answerString = answerString + string
        }

        if answerString == questionArray[1].quesDetail?.correctAnswer {
            guards[currentIndex].iscorrect = .right
        } else {
            guards[currentIndex].iscorrect = .wrong
        }
        usrMultipleAnser[currentIndex] = answerString
        let indexPath = IndexPath(item: 1, section: 0)
        self.collectionView.reloadItems(at: [indexPath])       
    }
    
    //显示题号列表
    @objc private func showQuesCollectionView(_ button: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        quesListBkgView.frame = window.bounds
        quesListBkgView.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        window.addSubview(quesListBkgView)
        let pageNum = idList.count
        isCorrected = []
        for i in 0..<pageNum {
            isCorrected.append(guards[i].iscorrect)
        }
        quesListCollectionView.contentSize = CGSize(width: deviceWidth - 20, height: 0.45 * deviceHeight)
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: pageNum, isCorrect: isCorrected)
        quesListCollectionView.reloadData()
        
        //题号列表弹出动画
        window.addSubview(quesListCollectionView)
        quesListCollectionView.frame = CGRect(x: 0, y: deviceHeight + 30, width: deviceWidth, height: 0.45 * deviceHeight)
        UIView.animate(withDuration: 0.3) {
            self.quesListCollectionView.frame = CGRect(x: 0, y: 0.55 * deviceHeight, width: deviceWidth, height: 0.45 * deviceHeight)
        }
        //添加手势判断
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hindQuesList))
        quesListBkgView.addGestureRecognizer(gesture)
    }
    
    @objc private func hindQuesList() {
        UIView.animate(withDuration: 0.3) {
            //尾随闭包播放弹出动画
            self.quesListCollectionView.frame = CGRect(x: 0, y: deviceHeight + 30, width: deviceWidth, height: 0.45 * deviceHeight)
            
            //提交一个延时任务线程
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.quesListCollectionView.removeFromSuperview()
                self.quesListBkgView.removeFromSuperview()
            }
        }
    }
}
