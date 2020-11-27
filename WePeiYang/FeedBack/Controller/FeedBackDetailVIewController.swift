//
//  FeedBackDetailVIewController.swift
//  WePeiYang
//
//  Created by 于隆祎 on 2020/9/15.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire


class FeedBackDetailViewController: UIViewController {
     // MARK: - UI
     
     var tableView: UITableView!
     var tabBarView: FBDetailTabBarView!
     var commentView: UIView!
     var textView: UITextView!
     
     //MARK: - Data
     var comments = [CommentModel]()
     var questionOfthisPage: QuestionModel?
     var tags = [TagModel]()
     var isLiked: Bool? {
          didSet {
               tabBarView.likeBtn.setImage(UIImage(named: isLiked ?? false ? "feedback_thumb_up_fill" : "feedback_thumb_up"), for: .normal)
          }
     }
     let commentCellID = "feedBackDVCCCell"
     let replyCellID = "feedBackDVCRCell"
     
     override func viewDidLoad() {
          super .viewDidLoad()
          setUp()
          
     }
     override func viewWillAppear(_ animated: Bool) {
          super .viewWillAppear(animated)
          
          loadData()
          
     }
}

// MARK: - UI
extension FeedBackDetailViewController {
     private func setUp() {
          navigationItem.title = "问题详情"
          view.backgroundColor = UIColor(hex6: 0xf6f6f6)
          
          let naviHeight = navigationController?.navigationBar.frame.maxY ?? 0
          tableView = UITableView(frame: CGRect(x: 0, y: naviHeight - 12, width: SCREEN.width, height: SCREEN.height - naviHeight - 70 + 12))
          tableView.backgroundColor = UIColor(hex6: 0xf6f6f6)
          tableView.dataSource = self
          tableView.delegate = self
          tableView.register(FBCommentTableViewCell.self, forCellReuseIdentifier: commentCellID)
          tableView.register(FBReplyTableViewCell.self, forCellReuseIdentifier: replyCellID)
          tableView.tableHeaderView = FBDetailHeaderView(question: questionOfthisPage ?? QuestionModel())
          tableView.keyboardDismissMode = .onDrag
          tableView.separatorStyle = .none
          view.addSubview(tableView)
          
          tabBarView = FBDetailTabBarView(frame: CGRect(x: 0, y: SCREEN.height - 70, width: SCREEN.width, height: 70))
          view.addSubview(tabBarView)
          tabBarView.likeBtn.addTarget(self, action: #selector(likeOrDislike), for: .touchUpInside)
          self.isLiked = questionOfthisPage?.isLiked
          tabBarView.commentBtn.add(for: .touchUpInside) {
               self.commentView.isHidden = false
               self.commentView.addShadow(.black, sRadius: 5, sOpacity: 0.3, offset: (0, -4))
               self.textView.becomeFirstResponder()
          }
          
          commentView = UIView()
          commentView.backgroundColor = .white
          self.view.addSubview(self.commentView)
          commentView.snp.updateConstraints { (make) in
               make.width.equalTo(SCREEN.width)
               make.height.equalTo(60)
               make.bottom.equalTo(view)
               make.centerX.equalTo(view)
          }
          
          textView = UITextView()
          commentView.addSubview(textView)
//          textView.layer.borderColor = UIColor.black.cgColor
//          textView.layer.borderWidth = 1
//          textView.layer.cornerRadius = 20
//          textView.layer.masksToBounds = true
          textView.text = "发表你的看法"
          textView.textColor = UIColor(hex6: 0xdbdbdb)
          textView.returnKeyType = .send
          // 防止圆角遮挡
          textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
          textView.font = .systemFont(ofSize: 18)
          textView.delegate = self
          self.textView.snp.updateConstraints { (make) in
               make.left.equalTo(self.commentView.snp.left).offset(10)
               make.centerY.equalTo(self.commentView.snp.centerY)
               make.width.equalTo(self.commentView.snp.width).offset(-30)
               make.height.equalTo(40)
          }
          commentView.isHidden = true
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
     }
     
     @objc func likeOrDislike() {
          if self.isLiked ?? false {
               QuestionHelper.dislikeQuestion(id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let str):
                         SwiftMessages.showSuccessMessage(body: str)
                         self.isLiked = false
                    case .failure(let err):
                         print(err)
                    }
               }
          } else {
               QuestionHelper.likeQuestion(id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let str):
                         SwiftMessages.showSuccessMessage(body: str)
                         self.isLiked = true
                    case .failure(let err):
                         print(err)
                    }
               }
          }
     }
     
     @objc func keyboardShow(note: Notification)  {
          guard let userInfo = note.userInfo else {return}
          guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{return}
          UIView.animate(withDuration: 1) {
               self.commentView.transform = CGAffineTransform.init(translationX: 0, y: -keyboardRect.height)
          }
     }
     @objc func keyboardDisappear(note: Notification)  {
          textView.endEditing(true)
          if textView.text == "" {
               textView.text = "发表你的看法"
               textView.textColor = UIColor(hex6: 0xdbdbdb)
          }
          self.commentView.isHidden = true
          UIView.animate(withDuration: 1) {
               self.commentView.transform = CGAffineTransform.identity
          }
     }
}

// MARK: - Data
extension FeedBackDetailViewController {
     private func loadData() {
          if questionOfthisPage?.solved == 1 {
               CommentHelper.commentGet(type: .answer, id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let answers):
                         self.comments = answers
                         CommentHelper.commentGet(id: self.questionOfthisPage?.id ?? 0) { (result) in
                              switch result {
                              case .success(let comments):
                                   self.comments += comments
                                   self.tableView.reloadData()
                              case .failure(let err):
                                   print(err)
                              }
                         }
                    case .failure(let err):
                         print(err)
                    }
               }
          } else {
               CommentHelper.commentGet(id: questionOfthisPage?.id ?? 0) { (result) in
                    switch result {
                    case .success(let comments):
                         self.comments = comments
//                         self.comments.insert(CommentModel(id: 123, contain: """
//                                                <div id="mainpage-a" class="mainpage-container">
//                                                <div class="mainpage-newsbox">
//                                                <div class="mainpage-title">你好～欢迎来到萌娘百科！</div>
//                                                <div class="mainpage-1stcontent">
//                                                <ul class="gallery mw-gallery-packed-hover margin-left-set" style="margin-left: 0.2em;">
//                                                          <li class="gallerybox" style="width: 106.371px;"><div style="width: 106.371px;">
//                                                               <div class="thumb" style="width: 104.371px;"><div style="margin:0px auto;"><a href="/%E8%AF%B7%E9%97%AE%E6%82%A8%E4%BB%8A%E5%A4%A9%E8%A6%81%E6%9D%A5%E7%82%B9%E5%85%94%E5%AD%90%E5%90%97"><img alt="请问您今天要来点兔子吗？BLOOM" src="https://img.moegirl.org.cn/common/thumb/8/83/Diantu3_KV2.jpg/127px-Diantu3_KV2.jpg" width="104" height="148" srcset="https://img.moegirl.org.cn/common/thumb/8/83/Diantu3_KV2.jpg/191px-Diantu3_KV2.jpg 1.5x, https://img.moegirl.org.cn/common/thumb/8/83/Diantu3_KV2.jpg/255px-Diantu3_KV2.jpg 2x" data-file-width="3590" data-file-height="5072"></a></div></div>
//                                                               <div class="gallerytextwrapper" style="width: 84.7461px;"><div class="gallerytext">
//                                                <p><a href="/%E8%AF%B7%E9%97%AE%E6%82%A8%E4%BB%8A%E5%A4%A9%E8%A6%81%E6%9D%A5%E7%82%B9%E5%85%94%E5%AD%90%E5%90%97" title="请问您今天要来点兔子吗">请问您今天要来点兔子吗？BLOOM</a>
//                                                </p>
//                                                               </div></div>
//                                                          </div></li>
//                                                          <li class="gallerybox" style="width: 106.371px;"><div style="width: 106.371px;">
//                                                               <div class="thumb" style="width: 104.371px;"><div style="margin:0px auto;"><a href="/LoveLive!%E8%99%B9%E5%92%B2%E5%AD%A6%E5%9B%AD%E5%AD%A6%E5%9B%AD%E5%81%B6%E5%83%8F%E5%90%8C%E5%A5%BD%E4%BC%9A/TV%E5%8A%A8%E7%94%BB%E4%BD%9C%E5%93%81"><img alt="LoveLive!虹咲学园学园偶像同好会" src="https://img.moegirl.org.cn/common/thumb/1/18/Llnijigaku_Anime_KV.jpg/127px-Llnijigaku_Anime_KV.jpg" width="104" height="148" srcset="https://img.moegirl.org.cn/common/thumb/1/18/Llnijigaku_Anime_KV.jpg/191px-Llnijigaku_Anime_KV.jpg 1.5x, https://img.moegirl.org.cn/common/thumb/1/18/Llnijigaku_Anime_KV.jpg/254px-Llnijigaku_Anime_KV.jpg 2x" data-file-width="990" data-file-height="1400"></a></div></div>
//                                                               <div class="gallerytextwrapper" style="width: 84.7461px;"><div class="gallerytext">
//                                                <p><a href="/LoveLive!%E8%99%B9%E5%92%B2%E5%AD%A6%E5%9B%AD%E5%AD%A6%E5%9B%AD%E5%81%B6%E5%83%8F%E5%90%8C%E5%A5%BD%E4%BC%9A/TV%E5%8A%A8%E7%94%BB%E4%BD%9C%E5%93%81" title="LoveLive!虹咲学园学园偶像同好会/TV动画作品">LoveLive!虹咲学园学园偶像同好会</a>
//                                                </p>
//                                                               </div></div>
//                                                          </div></li>
//                                                          <li class="gallerybox" style="width: 106.371px;"><div style="width: 106.371px;">
//                                                               <div class="thumb" style="width: 104.371px;"><div style="margin:0px auto;"><a href="/%E6%88%90%E7%A5%9E%E4%B9%8B%E6%97%A5"><img alt="成神之日" src="https://img.moegirl.org.cn/common/thumb/5/53/Kamisama-day_Anime_KV2.jpg/127px-Kamisama-day_Anime_KV2.jpg" width="104" height="148" data-file-width="1600" data-file-height="2265"></a></div></div>
//                                                               <div class="gallerytextwrapper" style="width: 84.7461px;"><div class="gallerytext">
//                                                <p><a href="https://www.baidu.com" title="成神之日">成神之日</a>
//                                                </p>
//                                                               </div></div>
//                                                          </div></li>
//                                                          <li class="gallerybox" style="width: 102.286px;"><div style="width: 102.286px;">
//                                                               <div class="thumb" style="width: 100.286px;"><div style="margin:0px auto;"><a href="/%E5%8D%8A%E5%A6%96%E7%9A%84%E5%A4%9C%E5%8F%89%E5%A7%AC"><img alt="半妖的夜叉姬" src="https://img.moegirl.org.cn/common/thumb/d/dc/Hanyo_no_Yashahime_KV.jpg/122px-Hanyo_no_Yashahime_KV.jpg" width="100" height="148" srcset="https://img.moegirl.org.cn/common/thumb/d/dc/Hanyo_no_Yashahime_KV.jpg/183px-Hanyo_no_Yashahime_KV.jpg 1.5x, https://img.moegirl.org.cn/common/thumb/d/dc/Hanyo_no_Yashahime_KV.jpg/244px-Hanyo_no_Yashahime_KV.jpg 2x" data-file-width="765" data-file-height="1127"></a></div></div>
//                                                               <div class="gallerytextwrapper" style="width: 80.9731px;"><div class="gallerytext">
//                                                <p><a href="/%E5%8D%8A%E5%A6%96%E7%9A%84%E5%A4%9C%E5%8F%89%E5%A7%AC" title="半妖的夜叉姬">半妖的夜叉姬</a>
//                                                </p>
//                                                               </div></div>
//                                                          </div></li>
//                                                          <li class="gallerybox" style="width: 106.371px;"><div style="width: 106.371px;">
//                                                               <div class="thumb" style="width: 104.371px;"><div style="margin:0px auto;"><a href="/%E9%AD%94%E6%B3%95%E7%A7%91%E9%AB%98%E4%B8%AD%E7%9A%84%E5%8A%A3%E7%AD%89%E7%94%9F"><img alt="魔法科高中的劣等生 来访者篇" src="https://img.moegirl.org.cn/common/thumb/1/18/Mahouka_S2KV.jpg/127px-Mahouka_S2KV.jpg" width="104" height="148" srcset="https://img.moegirl.org.cn/common/thumb/1/18/Mahouka_S2KV.jpg/190px-Mahouka_S2KV.jpg 1.5x, https://img.moegirl.org.cn/common/thumb/1/18/Mahouka_S2KV.jpg/254px-Mahouka_S2KV.jpg 2x" data-file-width="2560" data-file-height="3626"></a></div></div>
//                                                               <div class="gallerytextwrapper" style="width: 84.7461px;"><div class="gallerytext">
//                                                <p><a href="/%E9%AD%94%E6%B3%95%E7%A7%91%E9%AB%98%E4%B8%AD%E7%9A%84%E5%8A%A3%E7%AD%89%E7%94%9F" title="魔法科高中的劣等生">魔法科高中的劣等生 来访者篇</a>
//                                                </p>
//                                                               </div></div>
//                                                          </div></li>
//                                                          <li class="gallerybox" style="width: 106.371px;"><div style="width: 106.371px;">
//                                                               <div class="thumb" style="width: 104.371px;"><div style="margin:0px auto;"><a href="/%E6%88%98%E7%BF%BC%E7%9A%84%E5%B8%8C%E6%A0%BC%E5%BE%B7%E8%8E%89%E6%B3%95"><img alt="战翼的希格德莉法" src="https://img.moegirl.org.cn/common/thumb/3/3b/Sigrdrifa_KV2.webp/127px-Sigrdrifa_KV2.webp.png" width="104" height="148" srcset="https://img.moegirl.org.cn/common/thumb/3/3b/Sigrdrifa_KV2.webp/191px-Sigrdrifa_KV2.webp.png 1.5x, https://img.moegirl.org.cn/common/thumb/3/3b/Sigrdrifa_KV2.webp/254px-Sigrdrifa_KV2.webp.png 2x" data-file-width="707" data-file-height="1000"></a></div></div>
//                                                               <div class="gallerytextwrapper" style="width: 84.7461px;"><div class="gallerytext">
//                                                <p><a href="/%E6%88%98%E7%BF%BC%E7%9A%84%E5%B8%8C%E6%A0%BC%E5%BE%B7%E8%8E%89%E6%B3%95" title="战翼的希格德莉法">战翼的希格德莉法</a>
//                                                </p>
//                                                               </div></div>
//                                                          </div></li>
//                                                </ul>
//                                                <p><a href="/%E8%AF%B7%E9%97%AE%E6%82%A8%E4%BB%8A%E5%A4%A9%E8%A6%81%E6%9D%A5%E7%82%B9%E5%85%94%E5%AD%90%E5%90%97" title="请问您今天要来点兔子吗"><span lang="ja">ご注文はうさぎですか？</span></a> 今天是星期六，一共将有10部新番放送！Rabbit House和甘兔庵少女们欢声笑语的日常<a href="/%E8%AF%B7%E9%97%AE%E6%82%A8%E4%BB%8A%E5%A4%A9%E8%A6%81%E6%9D%A5%E7%82%B9%E5%85%94%E5%AD%90%E5%90%97" title="请问您今天要来点兔子吗">请问您今天要来点兔子吗？BLOOM</a>，<a href="/LoveLive!%E7%B3%BB%E5%88%97" title="LoveLive!系列">LoveLive!系列</a>第三代动画<a href="/LoveLive!%E8%99%B9%E5%92%B2%E5%AD%A6%E5%9B%AD%E5%AD%A6%E5%9B%AD%E5%81%B6%E5%83%8F%E5%90%8C%E5%A5%BD%E4%BC%9A/TV%E5%8A%A8%E7%94%BB%E4%BD%9C%E5%93%81" title="LoveLive!虹咲学园学园偶像同好会/TV动画作品">LoveLive!虹咲学园学园偶像同好会</a>，<a href="/%E9%BA%BB%E6%9E%9D%E5%87%86" title="麻枝准">麻枝准</a>时隔五年创作动画新作<a href="/%E6%88%90%E7%A5%9E%E4%B9%8B%E6%97%A5" title="成神之日">成神之日</a>，<a href="/%E7%8A%AC%E5%A4%9C%E5%8F%89" title="犬夜叉">犬夜叉</a>后代们的全新故事<a href="/%E5%8D%8A%E5%A6%96%E7%9A%84%E5%A4%9C%E5%8F%89%E5%A7%AC" title="半妖的夜叉姬">半妖的夜叉姬</a>，来自USNA的少女<a href="/%E9%AD%94%E6%B3%95%E7%A7%91%E9%AB%98%E4%B8%AD%E7%9A%84%E5%8A%A3%E7%AD%89%E7%94%9F" title="魔法科高中的劣等生">魔法科高中的劣等生来访者篇</a>，<a href="/%E9%95%BF%E6%9C%88%E8%BE%BE%E5%B9%B3" title="长月达平">长月达平</a>×<a href="/%E8%97%A4%E7%9C%9F%E6%8B%93%E5%93%89" title="藤真拓哉">藤真拓哉</a>×<a href="/A-1_Pictures" title="A-1 Pictures">A-1 Pictures</a>全新少女机战故事片<a href="/%E6%88%98%E7%BF%BC%E7%9A%84%E5%B8%8C%E6%A0%BC%E5%BE%B7%E8%8E%89%E6%B3%95" title="战翼的希格德莉法">战翼的希格德莉法</a>等都将于今日放送！
//                                                </p><p>2020年10月播放的动画有58部，新番数量明显回升，作品风格多样，类型广泛。不知道追哪部番好？到<a href="/%E6%97%A5%E6%9C%AC2020%E5%B9%B4%E7%A7%8B%E5%AD%A3%E5%8A%A8%E7%94%BB" title="日本2020年秋季动画"><b>日本2020年秋季动画专题</b></a>查阅吧～
//                                                </p><p>在查阅萌娘百科时注意到有错漏的话，就来<a href="/Help:%E8%90%8C%E5%A8%98%E7%99%BE%E7%A7%91%E7%BC%96%E8%BE%91%E7%9A%84%E5%BF%AB%E9%80%9F%E5%85%BB%E6%88%90%E6%96%B9%E6%B3%95-%E4%BB%8E%E5%85%A5%E9%97%A8%E5%88%B0%E7%B2%BE%E9%80%9A" class="mw-redirect" title="Help:萌娘百科编辑的快速养成方法-从入门到精通">参与编辑</a>，与我们一同完善萌娘百科吧~！
//                                                </p>
//                                                </div>
//                                                </div>
//                                                <div class="mainpage-box">
//                                                <div class="mainpage-title">最新条目</div>
//                                                <div class="mainpage-1stcontent">
//                                                <p>现有<a href="/Special:%E7%BB%9F%E8%AE%A1" title="Special:统计"><b>73,814</b></a>篇条目 <a href="/Special:%E7%BB%9F%E8%AE%A1" title="Special:统计"><b>2,110</b></a>位活跃编辑者
//                                                </p><p><a href="/%E6%B3%A2%E6%B6%8C%E4%B9%8B%E5%88%83" title="波涌之刃">波涌之刃</a>、<a href="/%E6%89%8E%E5%BE%B7%E6%8B%89%E7%BB%B4%E6%96%AF%C2%B7%E5%8A%A0%E6%8B%89%E5%8D%9A%E5%A4%AB" title="扎德拉维斯·加拉博夫">扎德拉维斯·加拉博夫</a>、<a href="/%E5%A4%9C%E8%A7%81%E4%BB%8B%E5%A4%A7" title="夜见介大">夜见介大</a>、<a href="/%E7%A2%A7%E8%93%9D%E8%88%AA%E7%BA%BF:Ju87c" title="碧蓝航线:Ju87c">碧蓝航线:Ju87c</a>、<a href="/%E7%B4%A7%E7%B4%A7%E6%8A%B1%E7%9D%80%E5%A5%B9_%E6%88%91%E7%9A%84%E8%80%81%E5%A9%86%E6%98%AF%E6%8A%B1%E6%9E%95" title="紧紧抱着她 我的老婆是抱枕">紧紧抱着她 我的老婆是抱枕</a>、<a href="/%E5%81%87%E9%9D%A2%E9%AA%91%E5%A3%AB%E9%BE%99%E9%AA%91(%E9%AA%91%E5%A3%AB)" title="假面骑士龙骑(骑士)">假面骑士龙骑(骑士)</a>、<a href="/%E7%A5%9E%E9%BE%99%E4%B9%8B%E8%B0%9C" title="神龙之谜">神龙之谜</a>、<a href="/%E7%BD%97%E4%BC%AF%E7%89%B9%C2%B7%E9%BB%84" title="罗伯特·黄">罗伯特·黄</a>、<a href="/%E7%A2%A7%E8%93%9D%E8%88%AA%E7%BA%BF:%E8%8E%AB%E5%A6%AE%E5%8D%A1" title="碧蓝航线:莫妮卡">碧蓝航线:莫妮卡</a>、<a href="/%E5%BF%83%E4%B8%AD%E7%9A%84%E7%97%9B%E6%A5%9A" title="心中的痛楚">心中的痛楚</a>、<a href="/TRIAL_DANCE" title="TRIAL DANCE">TRIAL DANCE</a>、<a href="/%E5%85%BD%E5%A8%98%E5%8A%A8%E7%89%A9%E5%9B%AD:%E5%8D%B0%E5%BA%A6%E8%B1%A1" title="兽娘动物园:印度象">兽娘动物园:印度象</a>、<a href="/%E9%93%BC%E5%A8%98" title="铼娘">铼娘</a>、<a href="/YELL_yell" title="YELL yell">YELL yell</a>、<a href="/%E7%A2%8D%E4%BA%8B" title="碍事">碍事</a>、<a href="/%E5%86%B7%E9%9B%A8" title="冷雨">冷雨</a>、<a href="/%E5%81%87%E9%9D%A2%E9%AA%91%E5%A3%AB%E5%93%8D%E9%AC%BC(%E9%AA%91%E5%A3%AB)" title="假面骑士响鬼(骑士)">假面骑士响鬼(骑士)</a>、<a href="/%E9%92%A2%E4%B9%8B%E7%82%BC%E9%87%91%E6%9C%AF%E5%B8%88/%E7%99%BB%E5%9C%BA%E8%A7%92%E8%89%B2" title="钢之炼金术师/登场角色">钢之炼金术师/登场角色</a>、<a href="/%E5%A5%B3%E7%A5%9E%E5%BC%82%E9%97%BB%E5%BD%953/%E5%A7%94%E6%89%98" title="女神异闻录3/委托">女神异闻录3/委托</a>、<a href="/Scattered_Glass" title="Scattered Glass">Scattered Glass</a>、<a href="/LoveLive!%E5%AD%A6%E5%9B%AD%E5%81%B6%E5%83%8F%E7%A5%AD/%E7%AC%AC55%E6%AC%A1%E4%BC%A0%E7%BB%9F%E6%B4%BB%E5%8A%A8" title="LoveLive!学园偶像祭/第55次传统活动">LoveLive!学园偶像祭/第55次传统活动</a>、<a href="/%E7%9C%8B%E4%B8%8D%E8%A7%81%E6%88%91" title="看不见我">看不见我</a>、<a href="/%E9%A3%8E%E8%B5%B7%E7%94%98%E9%9C%B2" title="风起甘露">风起甘露</a>、<a href="/%E4%B8%8E%E9%87%8E%E5%85%89" title="与野光">与野光</a>、<a href="/%E5%8F%AF%E7%9F%A5%E7%99%BD%E8%8D%89" title="可知白草">可知白草</a>
//                                                </p>
//                                                </div>
//                                                </div>
//                                                </div>
//                                                """,
//                                                           adminID: 123, score: 2.5, commit: nil, userID: nil, likes: 4, createdAt: "", updatedAt: "", username: "", isLiked: true), at: 0)
                         self.tableView.reloadData()
                    case .failure(let err):
                         print(err)
                    }
               }
          }
     }
}

// MARK: - Delegate

extension FeedBackDetailViewController: UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return comments.count
     }
     
     //MARK:- The content of the comment
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if comments[indexPath.row].adminID == nil {
               let cell = tableView.dequeueReusableCell(withIdentifier: commentCellID) as! FBCommentTableViewCell
               cell.update(comment: comments[indexPath.row])
               return cell
          } else {
               let cell = tableView.dequeueReusableCell(withIdentifier: replyCellID) as! FBReplyTableViewCell
               cell.update(comment: comments[indexPath.row])
               return cell
          }
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let comment = comments[indexPath.row]
          var str = comment.contain ?? ""
          var aStr: NSAttributedString?
          if comment.adminID != nil {
//               return 150
               aStr = comment.contain?.htmlToAttributedString
               return 60 + aStr!.getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 4)
          } else { str = comment.contain ?? "" }
          return 80 + str.getSuitableHeight(font: .systemFont(ofSize: 14), setWidth: SCREEN.width * 0.8, numbersOfLines: 0)
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let comment = comments[indexPath.row]
          if comment.adminID != nil {
               let detailVC = FBReplyDetailTVController(reply: comments[indexPath.row])
               navigationController?.pushViewController(detailVC, animated: true)
//               let detailVC = FBReplyDetailView(html: comment.contain ?? "")
//               UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {
//                    self.view.addSubview(detailVC)
//               }, completion: nil)
          }
     }
     
     func textViewDidChange(_ textView: UITextView) {
          if let lineHeight = textView.font?.lineHeight {
               let nowSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: lineHeight))
               let lines = floorf(Float(nowSize.height / lineHeight))
               if lines <= 5 {
                    let addedHeight = lineHeight * CGFloat(lines - 1)
                    commentView.snp.updateConstraints { (make) in
                         make.height.equalTo(60 + addedHeight)
                    }
                    textView.snp.updateConstraints { (make) in
                         make.height.equalTo(40 + addedHeight)
                    }
               }
          }
     }
     
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          if textView.text == "发表你的看法" {
               textView.text = ""
               textView.textColor = .black
          }
          if (text ==  "\n") {
               textView.resignFirstResponder()
               guard textView.text! != "" else {
                    return true
               }
               textView.endEditing(true)
               CommentHelper.addComment(questionId: (questionOfthisPage?.id)!, contain: textView.text) { (string) in
                    SwiftMessages.showSuccessMessage(body: "评论发布成功!")
                    self.loadData()
                    textView.text = "发表你的看法"
                    textView.textColor = UIColor(hex6: 0xdbdbdb)
               }
          }
          return true
     }
}

