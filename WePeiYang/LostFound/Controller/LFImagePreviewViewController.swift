//
//  LFImagePreviewViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/9/24.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SDWebImage

class LFImagePreviewViewController: UIViewController {
    
    var image = ""
    init(image: String) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
//        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = .black
        scrollView.isUserInteractionEnabled = true
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        print(image)
        
        imageView = UIImageView()
        if image != "" {
            if let imageURL = URL(string: image) {
                imageView.sd_setImage(with: imageURL)
            }
        }
        else {
            imageView.image = UIImage(named: "暂无图片")
        }
        imageView.isUserInteractionEnabled = true
        imageView.frame = scrollView.frame
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        self.view.addSubview(scrollView)
        
        //单击
        let tapSingle = UITapGestureRecognizer(target: self, action: #selector(tapSingleDid(_:)))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        
        //双击
        let tapDouble = UITapGestureRecognizer(target: self, action: #selector(tapDoubleDid(_:)))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        
        tapSingle.require(toFail: tapDouble)
        self.imageView.addGestureRecognizer(tapSingle)
        self.imageView.addGestureRecognizer(tapDouble)
        
        // Do any additional setup after loading the view.
    }
    
    // 视图显示时,隐藏导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // 视图消失时，显示导航栏
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
    
        return true
    }
    // 单击
    @objc func tapSingleDid(_ ges: UITapGestureRecognizer) {
    
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(!nav.isNavigationBarHidden, animated: true)
        }
    }
    // 双击
    @objc func tapDoubleDid(_ ges: UITapGestureRecognizer) {
    
        if let nav = self.navigationController {
            nav.setNavigationBarHidden(true, animated: true)
        }
        // 在点击处进行缩放
        UIView.animate(withDuration: 0.5, animations: {
            if self.scrollView.zoomScale == 1.0 {
                let pointInView = ges.location(in: self.imageView)
                let newZoomScale: CGFloat = 2.0
                let scrollViewSize = self.scrollView.bounds.size
                let w = scrollViewSize.width / newZoomScale
                let h = scrollViewSize.height / newZoomScale
                let x = pointInView.x - (w / 2.0)
                let y = pointInView.y - (h / 2.0)
                let rectToZoomTo = CGRect(x:x, y:y, width:w, height:h)
                self.scrollView.zoom(to: rectToZoomTo, animated: true)
            } else {
                self.scrollView.zoomScale = 1.0
            }
        
        })
        
//        if self.scrollView.zoomScale > CGFloat(1.0) {
//            self.scrollView.setZoomScale(1.0, animated: true)
//        } else {
//            self.scrollView.setZoomScale(1.5, animated: true)
//        }
    }
    


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

}
extension LFImagePreviewViewController: UIScrollViewDelegate {
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    // image中心缩放
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        var centerX = scrollView.center.x
//        var centerY = scrollView.center.y
//        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2: centerX
//        centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2: centerY
//        print(centerX, centerY)
//        imageView.center = CGPoint(x: centerX, y: centerY)
//        
//    }
    

}
