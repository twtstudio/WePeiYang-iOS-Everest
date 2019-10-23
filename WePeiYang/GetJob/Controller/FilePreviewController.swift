//
//  FilePreviewController.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/3/7.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
struct AttachHttp {
    static var http = ""
}
class FilePreviewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "预览"
        self.view.backgroundColor = .white
        
        let attachHttp: String = AttachHttp.http
        // 指定下载路径（文件名不变）
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            // 两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        //开始下载
        Alamofire.download(attachHttp, to: destination)
            .response { response in
                
                if let filePath = response.destinationURL?.path {
                    let url = URL(fileURLWithPath: filePath)
                    var webView = UIWebView(frame: CGRect(x: 0, y: 0, width: Device.width, height: Device.height))
                    self.view.addSubview(webView)
                    webView.loadRequest(URLRequest(url: url))
                }
        }
    }
}
