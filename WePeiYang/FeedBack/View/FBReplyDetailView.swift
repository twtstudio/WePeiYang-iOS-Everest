//
//  FBReplyDetailView.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/30.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import DynamicBlurView
import WebKit

class FBReplyDetailView: UIView {
     private var webView = WKWebView()
     private var blurView = DynamicBlurView(frame: SCREEN)
     
     init(html: String) {
          super.init(frame: SCREEN)
          blurView.blurRadius = 10
          blurView.isUserInteractionEnabled = true
          blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quit)))
          addSubview(blurView)
          webView.center = self.center
          webView.layer.cornerRadius = 15
          webView.layer.masksToBounds = true
          addSubview(webView)
          
          webView.snp.makeConstraints { (make) in
               make.center.equalTo(self)
               make.width.equalTo(SCREEN.width * 2 / 3)
               make.height.equalTo(SCREEN.height / 2)
          }
          
          let resizedHTML = html.appendingFormat("<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@",
                                                 SCREEN.width * 2 / 3 - 20)
          
          webView.loadHTMLString(resizedHTML, baseURL: nil)
     }
     
     @objc func quit() {
          var topVC = UIApplication.shared.keyWindow?.rootViewController
          while((topVC!.presentedViewController) != nil) {
               topVC = topVC!.presentedViewController
          }
          UIView.transition(with: (topVC?.view)!, duration: 0.2, options: [.transitionCrossDissolve], animations: {
               self.removeFromSuperview()
          }, completion: nil)
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
}
