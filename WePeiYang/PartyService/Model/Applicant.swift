//
//  Applicant.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class Applicant: NSObject {

    //FIXME: 还是需要保证数据的正确，再加载UI
    var realName: String? = TwTUser.shared.realname
    var studentNumber: String = TwTUser.shared.schoolID
    var personalStatus = [[String: Any]]()
    var scoreOf20Course = [[String: Any]]()
    var applicantGrade = [[String: Any]]()
    var academyGrade = [[String: Any]]()
    var probationaryGrade = [[String: Any]]()
    var handInHandler: [String: Any]?
    
    static let sharedInstance = Applicant()
    
    fileprivate override init(){}
    
    //TODO: 未完成
    func getStudentNumber(_ success: @escaping () -> Void) {
        //TODO:这样做还不够优雅，应该在登录完成之后自动重新加载
        guard let token = TwTUser.shared.token else {
            // FIXME: log something and login
//            MsgDisplay.showErrorMsg("你需要登录才能访问党建功能")
//            let loginVC = LoginViewController()
//            UIViewController.current?.present(loginVC, animated: true, completion: nil)
            return
        }
        
        let parameters = ["token": token]
            // as [String: AnyObject]
        //let parameters = ["token": "aabbcc"]
        SolaSessionManager.solaSession(type: .get, baseURL: "https://open.twtstudio.com/api/v2/auth/self", url: "", token: nil, parameters: parameters, success: { dict in
            guard let fooRealName = dict["realname"] as? String,
                let fooStudentNumber = dict["studentid"] as? String else {
//                    MsgDisplay.showErrorMsg("获取学号失败，请稍候再试")
                    return
            }
            
            self.realName = fooRealName
            self.studentNumber = fooStudentNumber

            UserDefaults.standard.set(self.studentNumber, forKey: "studentID")
            UserDefaults.standard.set(self.realName, forKey: "studentName")
            success()
        }, failure: { error in
//            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
        
//        let manager = AFHTTPSessionManager()
//        
//        manager.GET("http://open.twtstudio.com/api/v2/auth/self", parameters: parameters, success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
//            
//            let dic = responseObject as? NSDictionary
//            
//            guard let fooRealName = dict["realname"] as? String,
//                let fooStudentNumber = dict["studentid"] as? String else {
//                MsgDisplay.showErrorMsg("获取学号失败，请稍候再试")
//                    return
//            }
//            
//            self.realName = fooRealName
//            self.studentNumber = fooStudentNumber
//            
//
//            UserDefaults.standard.setObject(self.studentNumber, forKey: "studentID")
//            UserDefaults.standard.setObject(self.realName, forKey: "studentName")
//            //log.word("registered!")/
//
//            success()
//            
//            }, failure: { (task: URLSessionDataTask?, error: NSError) in
//                MsgDisplay.showErrorMsg("网络错误，请稍后再试")
//                print("error: \(error)")
//        })
        
    }
    
    
    func getPersonalStatus(_ doSomething: @escaping () -> ()) {
        
        //AFNetWorking/Alamofire Works
        
        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.personalStatusParams, success: { dict in
            
            guard dict["status"] as? NSNumber == 1 else {
//                MsgDisplay.showErrorMsg(dict["msg") as? String]
                return
            }
            
            guard let fooPersonalStatus = dict["status_id"] as? [[String: Any]] else {
//                MsgDisplay.showErrorMsg("获取个人状态失败，请稍后再试")
                return
            }
            
            self.personalStatus = fooPersonalStatus
//            MsgDisplay.dismiss()
            doSomething()
        }, failure: { error in
//            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
//        
//        let manager = AFHTTPSessionManager()
//        
//        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
//        
//        manager.GET(PartyAPI.rootURL,
//                    parameters: PartyAPI.personalStatusParams,
//                    progress: { (progress: Progress) in
//                        MsgDisplay.showLoading()
//                    },
//                    success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
//            
//                        let dic = responseObject as? NSDictionary
//            
//                        guard dict["status"] as? NSNumber == 1 else {
//                            MsgDisplay.showErrorMsg(dict["msg") as? String]
//                            return
//                        }
//                        
//                        guard let fooPersonalStatus = dict["status_id"] as? [NSDictionary] else {
//                            MsgDisplay.showErrorMsg("获取个人状态失败，请稍后再试")
//                            return
//                        }
//                        
//                        self.personalStatus = fooPersonalStatus
//                        MsgDisplay.dismiss()
//                        doSomething()
//                    },
//                    failure: { (task: URLSessionDataTask?, error: NSError) in
//                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
//                        print("error: \(error)")
//                    }
//        )
        
    }
    
    
    func get20score(_ doSomething: @escaping () -> ()) {
        
        let parameters = ["page": "api", "do": "20score", "sno": studentNumber]
        
        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: "", parameters: parameters, success: { dict in
            if dict["status"] as? NSNumber == 1 {
                self.scoreOf20Course = dict["score_info"] as! [[String: Any]]
                //print(self.scoreOf20Course)
            } else {
//                MsgDisplay.showErrorMsg(dict["msg"] as? String)
                return
            }
//            
//            MsgDisplay.dismiss()
            
            doSomething()
        }, failure: { error in
//            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
        
//        let manager = AFHTTPSessionManager()
//        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
//        
//        //真是诡异的代码风格
//        manager.GET(PartyAPI.rootURL,
//                    parameters: parameters,
//                    progress: { (progress: Progress) in
//                        MsgDisplay.showLoading()
//                    },
//                    success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
//                        let dic = responseObject as? NSDictionary
//                        //log.obj(dic!)/
//                        if dict["status"] as? NSNumber == 1 {
//                            self.scoreOf20Course = dict["score_info"] as! [NSDictionary]
//                            //print(self.scoreOf20Course)
//                        } else {
//                            MsgDisplay.showErrorMsg(dict["msg") as? String]
//                            return
//                        }
//                
//                        MsgDisplay.dismiss()
//            
//                        doSomething()
//            
//                    },
//                    failure: { (task: URLSessionDataTask?, error: NSError) in
//                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
//                        print("error: \(error)")
//                    }
//        )
        
    }
    
    func getGrade(_ testType: String, doSomething: @escaping () -> ()) {
        
        let parameters = ["page": "api", "do": "\(testType)_gradecheck", "sno": studentNumber]

        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: parameters, success: { dic in
            guard dic["status"] as? NSNumber == 1 else {
//                MsgDisplay.showErrorMsg(dict["message"] as? String)
                return
            }
            
            let dict = dic["data"]
            
            guard let fooGrade = dict as? [[String: Any]] else {
//                MsgDisplay.showErrorMsg("获取成绩失败，请稍后再试")
                return
            }
            
            if testType == "applicant" {
                self.applicantGrade = fooGrade
            } else if testType == "academy" {
                self.academyGrade = fooGrade
            } else if testType == "probationary" {
                self.probationaryGrade = fooGrade
            }
            
//            MsgDisplay.dismiss()
            
            doSomething()
        }, failure: { error in
//            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
        
//        let manager = AFHTTPSessionManager()
//        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
//        
//        manager.GET(PartyAPI.rootURL,
//                    parameters: parameters,
//                    progress: { (progress: Progress) in
//                        MsgDisplay.showLoading()
//                    },
//                    success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
//            
//                        let dic = responseObject as? NSDictionary
//            
//                        guard dict["status"] as? NSNumber == 1 else {
//                            MsgDisplay.showErrorMsg(dict["message") as? String]
//                            return
//                        }
//            
//                        let dict = dict["data"]
//                
//                        guard let fooGrade = dict as? [NSDictionary] else {
//                            MsgDisplay.showErrorMsg("获取成绩失败，请稍后再试")
//                            return
//                        }
//                        
//                        if testType == "applicant" {
//                            self.applicantGrade = fooGrade
//                        } else if testType == "academy" {
//                            self.academyGrade = fooGrade
//                        } else if testType == "probationary" {
//                            self.probationaryGrade = fooGrade
//                        }
//                
//                        MsgDisplay.dismiss()
//            
//                        doSomething()
//                    },
//                    failure: { (task: URLSessionDataTask?, error: NSError) in
//                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
//                        print("error: \(error)")
//                    }
//        )
        
    }
    
    func complain(_ ID: String, testType: String, title: String, content: String, doSomething: @escaping () -> ()) {
        
        let parameters = ["page": "api", "do": "\(testType)_shensu", "sno": studentNumber, "test_id": ID, "title": title, "content": content]
        
        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: parameters, success: { dict in
            
            guard dict["status"] as? NSNumber == 1 else {
                //                MsgDisplay.showErrorMsg(dict["message"] as! String)
                return
            }
            
            //            MsgDisplay.showSuccessMsg(dict["msg"] as! String)
            doSomething()
        }, failure: { error in
            //            MsgDisplay.showErrorMsg("网络错误，请稍后再试")
            print("error: \(error)")
        })
        
//        let manager = AFHTTPSessionManager()
//        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
//        
//        manager.GET(PartyAPI.rootURL,
//                    parameters: parameters,
//                    progress: { (progress: Progress) in
//                        MsgDisplay.showLoading()
//                    },
//                    success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
//                        let dic = responseObject as? NSDictionary
//            
//                        guard dict["status"] as? NSNumber == 1 else {
//                            MsgDisplay.showErrorMsg(dict["message") as! String]
//                            return
//                        }
//                        
//                        MsgDisplay.showSuccessMsg(dict["msg") as! String]
//                        doSomething()
//                    },
//                    failure: { (task: URLSessionDataTask?, error: NSError) in
//                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
//                        print("error: \(error)")
//                    }
//        )
        
        
    }
    
    func handIn(_ title: String, content: String, fileType: Int, doSomething: @escaping () -> ()) {
        let parameters = ["message_title": title, "message_content": content, "submit": "", "file_type": "\(fileType)"] as [String : String]
        
        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.handInURL, url: "", token: nil, parameters: parameters, success: { dict in
            guard dict["status"] as? Int == 1 else {
                if let msg = dict["msg"] as? String {
                    SwiftMessages.showErrorMessage(body: msg)
                }
                return
            }
            
            if let msg = dict["msg"] as? String {
                SwiftMessages.showSuccessMessage(body: msg)
            } else {
                SwiftMessages.showSuccessMessage(body: "递交成功")
            }
            
            doSomething()
        }, failure: { error in
            SwiftMessages.showSuccessMessage(body: error.localizedDescription)
        })
        
//        let manager = AFHTTPSessionManager()
//        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html")
//        
//        manager.POST(PartyAPI.handInURL,
//                    parameters: parameters,
//                    progress: { (progress: Progress) in
//                        MsgDisplay.showLoading()
//                    },
//                    success: { (task: URLSessionDataTask, responseObject: AnyObject?) in
//                        let dic = responseObject as? NSDictionary
//                        
//                        print(dic)
//                        
//                        guard dict["status"] as? NSNumber == 1 else {
//                            MsgDisplay.showErrorMsg(dict["msg") as! String]
//                            return
//                        }
//                        
//                        if let msg = dict["msg"] as? String {
//                            MsgDisplay.showSuccessMsg(msg)
//                        } else {
//                            MsgDisplay.showSuccessMsg("递交成功")
//                        }
//                        
//                        doSomething()
//                    },
//                    failure: { (task: URLSessionDataTask?, error: NSError) in
//                        MsgDisplay.showErrorMsg("网络错误，请稍后再试")
//                        print("error: \(error)")
//            }
//        )
        
    }
    
    func handlePersonalStatus(_ doSomething: () -> ()) {
        
        for dict in personalStatus {
            guard dict["status"] as? Int == 1, dict["type"] as? Int != nil else {
                continue
            }
//            guard dict.object(forKey: "status") as? Int == 1 else {
//                continue
//            }
//            
//            guard dict.object(forKey: "type") as? Int != nil else {
//                continue
//            }
            
            handInHandler = dict
            doSomething()
            return
        }
        
        //Nothing to hand in
        handInHandler = nil
        doSomething()
    }
    
    
}
