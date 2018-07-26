//
//  PracticeCollectionView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/23.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class ExerciseCollectionViewController: UIViewController {
    var questions: [Question] = []
    var answers: [Answer] = []
    
    //逻辑哨兵
    var iscollected = false
    var currentPage = 1
    var lastoffset: CGFloat = 0

    let orderLabel = UILabel()
    let practiceBlue = UIColor(hex6: 0x42a1e3)
    
    let result: String? = "正确"
    let rightAnswer: String? = "通过更改数据源来给用户一个假象，图片在无限滚动（其实一共只有3个 cell），默认显示第一个，右滑 index + 1, 左滑 index - 1，然后修改数据源，异步回到第一个cell（注意不能有动画）通过更改数据源来给用户一个假象，图片在无限滚动（其实一共只有3个 cell），默认显示第一个，右滑 index + 1, 左滑 index - 1，然后修改数据源，异步回到第一个cell（注意不能有动画）"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //制作一个假的数据
        for _ in 0..<5 {
            let question = Question(id: 99, course_id: 00, type: 1, content: "ssfsfksfj", option: [])
            questions.append(question)
        }
        
//    546666666
        for i in 0..<questions.count {
            let answer = Answer(ques_id: questions[i].id, answer: nil ,type: questions[i].type)
            answers.append(answer)
        }
        
        initcollectionView()
        setupButtons()
        setupSaperator()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentoffset: CGFloat = scrollView.contentOffset.x
        
        currentPage = Int(currentoffset / deviceWidth) + 1
        orderLabel.text = "\(currentPage)/\(questions.count)"
    }
    
//    func reloadData() {
//        var datas: [String?] {
//            var firstIndex = 0
//            var secondIndex = 0
//            var thirdIndex = 0
//            
//            switch questions.count {
//            case 0:
//                return []
//            case 1:
//                break
//            default:
//                firstIndex = 
//            }
//        }
//    }
    
    func initcollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentSize = CGSize(width: deviceWidth * 3, height: deviceHeight)
        collectionView.isPagingEnabled = true
        collectionView.register(ExerciseCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.width.equalTo(deviceWidth)
            make.height.equalTo(deviceHeight)
            make.center.equalTo(view)
        }
    }
    
    func setupButtons() {
        let offset = 0.05 * deviceWidth
        let buttonsViewW = QuestionViewParameters.questionViewW
        let buttonsViewH = 0.05 * deviceHeight
        
        let buttonsView = UIView()
        buttonsView.backgroundColor = .clear
        
        let collectBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            return btn
        }()
        
        let showBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "questions"), for: .normal)
            return btn
        }()
        
        let checkBtn: UIButton = {
            let btn = UIButton()
            btn.backgroundColor = .white
            btn.setTitle("查看答案", for: .normal)
            btn.setTitleColor(practiceBlue, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.layer.cornerRadius = 0.4 * buttonsViewH
            btn.layer.borderWidth = 1
            btn.layer.borderColor = practiceBlue.cgColor
            return btn
        }()
        
        collectBtn.addTarget(self, action: #selector(collect(_:)), for: .touchUpInside)
//        checkBtn.
        
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
        
        orderLabel.text = "\(currentPage)/\(questions.count)"
        buttonsView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.width.equalTo(2 * buttonsViewH)
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
    
    @objc func collect(_ button: UIButton) {
        if iscollected {
            button.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            iscollected = false
        }else {
            button.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
            iscollected = true
        }
    }
    
    
}

extension ExerciseCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: deviceWidth, height: deviceHeight)
    }
}

extension ExerciseCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ExerciseCell
        cell.initExerciseCell()
        
//        cell.addAnswerView(result: result, answer: answer)
        return cell
    }
    
}
