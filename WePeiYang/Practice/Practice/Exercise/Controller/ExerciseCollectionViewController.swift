//
//  PracticeCollectionView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/23.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

enum isCorrect {
    case right
    case wrong
    case unknown
}
enum Direction {
    case left
    case right
    case none
}

enum PracticeMode {
    case memorize
    case exercise
}

struct Guard {
    //哨兵
    var iscollected: Bool = false
    var ischecked: Bool = false
    var isMistake: Bool = false
    var iscorrect: isCorrect = .unknown
    var answer: String?
    var selected: Bool = false
}



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
    
    var scrollDirect: Direction = .none
    var mode: PracticeMode = .exercise
    
    var classId = 2
    var courseId = 2
    var quesType = 0

    var currentPage = 1
    var lastoffset: CGFloat = deviceWidth
    var currentoffset: CGFloat = 0
    var indexArray: [Int] = []

    let orderLabel = UILabel()
    
    let result: String? = "正确"
    let rightAnswer: String? = "A"

    let collectBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
        return btn
    }()
    
    let checkBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("查看答案", for: .normal)
        return btn
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let quesListCollectionView = QuesCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //制作一个假的数据
//        for _ in 0..<58 {
//            id.append(888)
//        }
//        indexArray = [id.count, 1, 2]
//
//        for i in 0..<id.count {
//            let questionDetail = QuestionDetails(id: id[i], classId: classId, courseId: courseId, type: quesType, content: "以下不属于共同的论证评价标准的是()。以下不属于共同的论证评价标准的是()。", option: ["逻辑标准", "修辞标准", "论辩标准", "分析标准"], correctAnswer: "A", isCollected: 0, isMistake: 0)
////            let questionDetail = QuestionDetails(id: id[i], courseId: courseId, type: quesType, content: "以下不属于共同的论证评价标准的是()。以下不属于共同的论证评价标准的是()。", option: ["逻辑标准", "修辞标准", "论辩标准", "分析标准"])
//            let question = Question(status: 0, quesDetail: questionDetail)
//            questions.append(question)
////请求部分
////            let answer = Answer(ques_id: questions[i].ques?.id, answer: nil ,type: questions[i].ques?.type)
////            answers.append(answer)
//
//            let guarding = Guard()
//            guards.append(guarding)
//        }
       
        initcollectionView()
        setupSaperator()
        getIdList(courseId: courseId, quesType: quesType)
                
        NotificationCenter.default.addObserver(self, selector: #selector(updateAnswer), name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeQues), name: NSNotification.Name(rawValue: "changeQues"), object: nil)
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

        if let content = ques.quesDetail?.content, let optionArray = ques.quesDetail?.option, let correctAns = ques.quesDetail?.correctAnswer {
            cell.loadQues(ques: content, options: optionArray, selected: guards[currentPage - 1].selected, rightAns: correctAns)
            cell.questionView.reloadData()
        }else {
            cell.loadQues(ques: "oops, no data", options: ["oops, no data", "oops, no data", "oops, no data", "oops, no data"], selected: guards[currentPage - 1].selected, rightAns: "no data")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        quesListCollectionView.removeFromSuperview()
    }
}

//网络请求
extension ExerciseCollectionViewController {
    
    func getIdList(courseId: Int, quesType: Int) {
        //这里会先运行 PracticeNetwork.getIdList
        var idList: [Int?] = []
        PracticeNetwork.getIdList(courseId: courseId, quesType: quesType, success: { (idArray) in
            idList = idArray
            self.indexArray = [idList.count - 1, 0, 1]
            for _ in 0..<idList.count {
                let guarding = Guard()
                self.guards.append(guarding)
            }
            
            self.idList = idList
            self.loadData()
        }) { (err) in
            print(err)
        }
    }
    
    func getQues(id: Int) {
//        print("正在获取\(id)")
        PracticeNetwork.getQues(courseId: courseId, quesType: quesType, id: id, success: { (ques) in
            self.count = self.count + 1
            
            if self.count == 3 {
                self.count = 0
                var qs: [Question] = []
                
                //调整题目顺序，因为返回题目的顺序和网速有关，不是先请求的题目就一定先返回。所以返回的数组大部分为乱序。
                for i in 0..<3 {
                    for j in 0..<3 {
                        let ques = ExerciseCollectionViewController.questions[j]
                        if ques.quesDetail!.id == self.idList[self.indexArray[i]] {
                            qs.append(ques)
                        }
                    }
                }
                //
                
                for i in 0..<3 {
                    switch qs[i].quesDetail?.isCollected {
                    case 0:
                        self.guards[self.indexArray[i]].iscollected = false
                    case 1:
                        self.guards[self.indexArray[i]].iscollected = true
                    default:
                        break
                    }
                    
                    switch qs[i].quesDetail?.isMistake {
                    case 0:
                        self.guards[self.indexArray[i]].isMistake = false
                    case 1:
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
                    self.collectionView.reloadData()
                }
            }
            
        }) { (err) in
            print(err)
        }
    }
    
    func getQuesArray() {
        ExerciseCollectionViewController.questions = []
        for index in indexArray {
            print(index)
            print(currentPage)
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

//页面切换
extension ExerciseCollectionViewController {
    
    func updateData() {
        //页面记录更新
        let currentIndex = currentPage - 1
        let lastIndex = (currentIndex - 1) == -1 ? idList.count - 1 : (currentIndex - 1)
        let nextIndex = (currentIndex + 1) == idList.count ? 0 : (currentIndex + 1)
        indexArray = [lastIndex, currentIndex, nextIndex]

        getQuesArray()
        orderLabel.textAlignment = .center
        orderLabel.text = "\(currentPage)/\(idList.count)"
        
        //判断是否收藏
        if guards[currentPage - 1].iscollected {
            collectBtn.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
        }else {
            collectBtn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
        }
        
        //判断是否查看答案
        if guards[currentPage - 1].ischecked {
            checkBtn.setTitle("隐藏答案", for: .normal)
        }else {
            checkBtn.setTitle("查看答案", for: .normal)
        }
        
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: idList.count, isCorrect: isCorrected)
        quesListCollectionView.reloadData()
    }
    
    //判断滑动方向
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        questions = []
        currentoffset = scrollView.contentOffset.x
        let offset = lastoffset - currentoffset
        if offset >= deviceWidth {
            scrollDirect = .right
        } else if offset <= -deviceWidth {
            scrollDirect = .left
        }
        
        switch scrollDirect {
        case .left:
            currentPage = (currentPage + 1) == idList.count + 1 ? 1 : (currentPage + 1)
            updateData()
            scrollView.contentOffset.x = deviceWidth
        case .right:
            currentPage = (currentPage - 1) == 0 ? idList.count : (currentPage - 1)
            updateData()
            scrollView.contentOffset.x = deviceWidth
        default:
            break
        }
        scrollDirect = .none
    }
    
}

//界面初始化、基本控件加载、点击事件
extension ExerciseCollectionViewController {
    
    func loadData() {
        getQuesArray()
//        print(questions)
        setupButtons()
    }
    
    @objc func removeQuesCollectionView() {
        quesListCollectionView.removeFromSuperview()
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
        
        let buttonsView = UIView()
        buttonsView.backgroundColor = .clear
        
        let showBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "questions"), for: .normal)
            return btn
        }()
        
        checkBtn.setTitleColor(UIColor.practiceBlue, for: .normal)
        checkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        checkBtn.layer.cornerRadius = 0.4 * buttonsViewH
        checkBtn.layer.borderWidth = 1
        checkBtn.layer.borderColor = UIColor.practiceBlue.cgColor
        
        collectBtn.addTarget(self, action: #selector(collect(_:)), for: .touchUpInside)
        checkBtn.addTarget(self, action: #selector(check(_:)), for: .touchUpInside)
        showBtn.addTarget(self, action: #selector(showQuesCollectionView(_:)), for: .touchUpInside)
        
        let offsetY = 0.2 * deviceHeight
        //        let offsetX = 0.18 * deviceWidth
        let offsetm = 0.004 * deviceHeight
        
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) in
            make.width.equalTo(buttonsViewW)
            make.height.equalTo(buttonsViewH)
            make.centerY.equalTo(view).offset(offsetY)
            make.centerX.equalTo(view)
        }
        
        buttonsView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(0.8 * buttonsViewH)
            make.left.equalTo(buttonsView)
            make.centerY.equalTo(buttonsView).offset(offsetm)
        }
        
        orderLabel.textAlignment = .center
        orderLabel.text = "\(currentPage)/\(idList.count)"
        buttonsView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.width.equalTo(2.2 * buttonsViewH)
            make.height.equalTo(buttonsViewH)
            make.right.top.equalTo(buttonsView)
        }
        
        // showBtn和collectBtn 的 make.right.equalTo()无效。很迷。
        buttonsView.addSubview(showBtn)
        showBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(buttonsViewH)
            make.top.equalTo(buttonsView)
            make.left.equalTo(orderLabel).offset(-(offset + buttonsViewH))
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
        if let answer = guards[currentPage - 1].answer {
            if answer == questionArray[1].quesDetail!.correctAnswer {
                guards[currentPage - 1].iscorrect = .right
            }else {
                guards[currentPage - 1].iscorrect = .wrong
                
                let mistakeQuesData: Dictionary<String, Any> = ["tid": 1,
                                                                "ques_id": questionArray[1].quesDetail?.id ?? 0,
                                                                "ques_type": questionArray[1].quesDetail?.type ?? 3,
                                                                "error_option": answer]
                PracticeNetwork.postMistakeQues(courseId: courseId, data: mistakeQuesData, failure: { (err) in
                    print(err)
                }) { (dic) in
//                    print(dic)
                }
            }
        } else {
            return
        }
        check(checkBtn)
    }
    
    @objc func changeQues() {
        currentPage = QuesCollectionView.chosenPage
        updateData()
    }
    
    //收藏
    @objc func collect(_ button: UIButton) {
        if guards[currentPage - 1].iscollected {
            guards[currentPage - 1].iscollected = false
            button.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            
            let ques = questionArray[1].quesDetail!
            let data: Dictionary<String, Any> = ["tid": 0,
                                                 "ques_type": ques.type!,
                                                 "ques_id": ques.id!]
            PracticeNetwork.addCollection(data: data, failure: { (err) in
                print(err)
            }) { (dic) in
                //收藏后动作
                print("收藏成功")
            }
        }else {
            guards[currentPage - 1].iscollected = true
            button.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
            let ques = questionArray[1].quesDetail!
            let data: Dictionary<String, Any> = ["tid": 0,
                                                 "ques_type": ques.type!,
                                                 "ques_id": ques.id!]
            PracticeNetwork.deleteCollection(data: data, failure: { (err) in
                print(err)
            }) { (dic) in
                //取消收藏后动作
                print("已取消收藏")
            }
        }
    }
    
    //查看答案、隐藏答案
    @objc func check(_ button: UIButton) {
        if guards[currentPage - 1].selected == true {
            button.setTitle("隐藏答案", for: .normal)
            guards[currentPage - 1].ischecked = true
            
            let indexPath = IndexPath(item: 1, section: 0)
            self.collectionView.reloadItems(at: [indexPath])
            QuestionTableView.selectedAnswer = nil
            return
        }
        
        if guards[currentPage - 1].ischecked {
            button.setTitle("查看答案", for: .normal)
            guards[currentPage - 1].ischecked = false
            
            let indexPath = IndexPath(item: 1, section: 0)
            self.collectionView.reloadItems(at: [indexPath])
        }else {
            button.setTitle("隐藏答案", for: .normal)
            guards[currentPage - 1].ischecked = true
            
            let indexPath = IndexPath(item: 1, section: 0)
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    //显示题号列表
    @objc func showQuesCollectionView(_ button: UIButton) {
        let pageNum = idList.count
        isCorrected = []
        for i in 0..<pageNum {
            isCorrected.append(guards[i].iscorrect)
        }
        quesListCollectionView.initCollectionView(currentPage: currentPage, pagesNum: pageNum, isCorrect: isCorrected)
        quesListCollectionView.reloadData()
        view.addSubview(quesListCollectionView)
        quesListCollectionView.snp.makeConstraints { (make) in
            make.width.equalTo(0.45 * deviceWidth)
            make.height.equalTo(0.3 * deviceHeight)
            make.centerX.equalTo(view).offset(0.05 * deviceWidth)
            make.centerY.equalTo(view)
        }
    }
}

















