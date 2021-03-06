//
//  StarRateView.swift
//  StarRateView
//
//  Created by mac on 2019/4/1.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit

public enum StarType{
     
     /// 整颗星星
     case `default`
     /// 半颗星星
     case half
     /// 不限制
     case unlimited
}


public class FBStarRateView: UIView {
     
     /// 默认整颗星星
     lazy var starType:StarType = .unlimited
     
     /// 是否滑动,default is true
     var isInteractable = true {
          didSet{
               if isInteractable {
                    /// 滑动手势
                    let pan = UIPanGestureRecognizer(target: self,action: #selector(startPan))
                    
                    addGestureRecognizer(pan)
                    
                    /// 点击手势
                    let tap = UITapGestureRecognizer(target: self, action: #selector(startTap))
                    
                    addGestureRecognizer(tap)
               }
          }
     }
     
     /// 星星的间隔,default is 5.0
     lazy var starSpace:CGFloat = 5.0
     
     /// 当前的星星数量,default is 0
     lazy var currentStarCount:CGFloat = 0
     
     /// 上次评分
     lazy var lastScore:CGFloat = -1
     
     /// 最少星星
     lazy var leastStar:CGFloat = 0
     
     /// 星星总数量,default is 5
     lazy var totalStarCount:CGFloat = 5
     
     /// 动画时间,default is 0.1
     lazy var animateDuration = 0.1
     
     /// 灰色星星视图
     lazy var unStarView:UIView = .init()
     
     /// 点亮星星视图
     lazy var starView:UIView = .init()
     
     /// 评分回调
     var scoreCallBack:((CGFloat)->())?
     
     
     // MARK: - 对象实例化
     public convenience init?(frame: CGRect, progressImg: UIImage?, trackImg: UIImage?) {
          let width = frame.size.width
          let height = frame.size.height
          var computedSpace: CGFloat = 0
          if height * 5 <= width {
               computedSpace = (width - height * 5) / 4
          } else {
               // TODO: 这里还得等读完这个轮子才能写
               computedSpace = 0
          }
          
          
          self.init(frame:frame, totalStarCount:5.0, currentStarCount:0.0, starSpace: computedSpace, progressImg: progressImg, trackImg: trackImg)
     }
     
     public init?(frame:CGRect, totalStarCount:CGFloat, currentStarCount:CGFloat, starSpace:CGFloat, progressImg: UIImage?, trackImg: UIImage?) {
          if progressImg == nil || trackImg == nil {
               return nil
          }
          
          super.init(frame: frame)
          
          self.totalStarCount = totalStarCount
          
          self.currentStarCount = currentStarCount
          
          self.starSpace = starSpace
          
          unStarView = setupStarView(trackImg!)
          
          addSubview(unStarView)
          
          starView = setupStarView(progressImg!)
          
          insertSubview(starView, aboveSubview: unStarView)
          
          showStarRate()
          
     }
     
     required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
}




// MARK: - CustomMethod
public extension FBStarRateView{
     
     func setScore(f: CGFloat) {
          currentStarCount = f
          showStarRate()
     }
     
    func show(type: StarType = .default, isInteractable: Bool = true, leastStar: CGFloat = 0, completion: ((_ score:CGFloat)->())? = nil) {
          
          self.starType = type

          self.isInteractable = isInteractable
          
          self.leastStar = leastStar
          
          self.scoreCallBack = completion
          
     }
     
}



// MARK: - UI
extension FBStarRateView{
     
     /// 绘制星星UI
     fileprivate func setupStarView(_ img: UIImage) -> UIView {
          
          let starView = UIView(frame: bounds)
          
          starView.clipsToBounds = true
          
          let stackView = UIStackView(frame: bounds)
          
          stackView.axis = .horizontal
          
          stackView.distribution = .fillEqually
          
          stackView.spacing = starSpace
          
          starView.addSubview(stackView)
          
          //添加星星
          for _ in 0..<Int(totalStarCount) {
               
               let image = img
               
               let imageView = UIImageView(image: image)
               
               stackView.addArrangedSubview(imageView)
               
          }
          return starView
     }
     
     
     /// 显示评分
     fileprivate func showStarRate(){
          UIView.animate(withDuration: animateDuration, animations: {
               
               var count = self.currentStarCount
               
               if count < self.leastStar {
                    
                    count = self.leastStar
                    
               }
               
               let spaceCount = ceil(count)
               
               let boundsW = self.bounds.width - (self.totalStarCount - 1) * self.starSpace
               
               let boundsH = self.bounds.height
               
               var starW:CGFloat = 0
               
               switch self.starType{
               
               case .default:
                    
                    count = ceil(count)
                    
               case .half:
                    
                    count = ceil(count * 2) / 2
                    
               case .unlimited:
                    break
               }
               
               if self.lastScore == count{
                    return
               }else{
                    self.lastScore = count
               }
               
               self.scoreCallBack?(count)
               
               starW = count / self.totalStarCount * boundsW + (spaceCount - 1) * self.starSpace
               
               if starW < 0 {
                    starW = 0
               }
               
               self.starView.frame = CGRect(x: 0, y: 0, width: starW, height: boundsH)
          })
     }
     
}




// MARK: - 手势交互
extension FBStarRateView{
     
     /// 滑动评分
     @objc func startPan(_ pan:UIPanGestureRecognizer) {
          
          var offX:CGFloat = 0
          
          if pan.state == .began{
               
               offX = pan.location(in: self).x
               
          }else if pan.state == .changed{
               
               offX += pan.location(in: self).x
               
          }else{
               
               return
          }
          
          if offX < 0 {
               
               offX = 0
               
          }
          
          if offX > bounds.maxX {
               
               offX = bounds.maxX
          }
          
          currentStarCount = offX / bounds.width * totalStarCount
          
          showStarRate()
          
     }
     
     /// 点击评分
     @objc func startTap(_ tap:UITapGestureRecognizer) {
          
          let offX = tap.location(in: self).x
          
          currentStarCount = offX / bounds.width * totalStarCount
          
          showStarRate()
          
     }
     
     
     
     
}
