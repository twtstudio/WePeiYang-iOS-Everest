//
//  PublishLostViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import Photos

class PublishLostViewController: UIViewController, UITextFieldDelegate {
    
    var tableView: UITableView!
    var markDict = [String: Any]()
    var mark: LFMarkCustomCell!
    var tag: String!
    var index = 0
    var pushTag = ""
    var newTitle = ""
    
    var function = [
        ["添加图片"],
        ["标题 *", "时间", "校区 *", "地点"],
        [],
        ["姓名 *", "联系电话 *"],
        ["物品描述"],
        ["刊登时长 *"],
        []
    ]
    
    var text = [
        0: [""],
        1: ["(不超过11个字)", "请填写详细时间", "请填写校区 (北洋园 / 卫津路)", "请填写详细地点"],
        2: ["", ""],
        3: ["", ""],
        4: ["请认真填写物品信息"],
        5: ["默认时间为7day"]
    ]
    
    var header = [
        0: ["发布图片"],
        1: ["详细信息"],
        2: ["类型"],
        3: ["联系方式"],
        4: ["附加信息"],
        5: ["发布时间"],
        6: ["物品状态"]
    ]
    
    var returnKeys = [
        0: ["pic[]"],
        1: ["title", "time", "campus", "place"],
        2: ["card_number", "card_name"],
        3: ["name", "phone"],
        4: ["item_description"],
        5: ["duration"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = newTitle
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex6: 0xeeeeee)
        
        self.tableView.estimatedRowHeight = 500
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor(hex6: 0x00a1e9)
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.systemFont(ofSize: 15)
        
        touchOutsideTextField()
        
        let headerMark = LFMarkCustomCell()
        headerMark.enumerated()
        headerMark.label.text = "类型"
        headerMark.delegate = self
        mark = headerMark
        
        if index == 1 {
            function[6] = ["是否交还"]
        }
    }
    
    @objc func dismissKeyboard() {
        self.tableView.endEditing(true)
    }
    
    // 确定按钮的回调
    @objc func tapped() {
        
//        PostLostAPI.postLost(markDic: markDict, tag: pushTag, success: { _ in
//            let successVC = PublishSuccessViewController()
//            self.navigationController?.pushViewController(successVC, animated: true)
//        }, failure: { _ in
//        })
        if String(describing: markDict["地点"]).contains("北洋") {
            self.markDict["campus"] = "1"
        } else {
            self.markDict["campus"] = "2"
        }
        markDict["detail_type"] = "12"
        markDict["recapture_place"]  = ""
        markDict["recapture_entrance"] = "0"
        log(markDict)
        LostFoundHelper.postLost(dic: markDict, success: { _ in
            log("SUCCESS")
            self.navigationController?.pushViewController(PublishSuccessViewController(), animated: true)
        }, failure: { _ in
            log("FAILURE")
        })
    }
    
    func comfirmButtonTapped() {
        //        LostAPI.fabu(name: )
    }
    
    func means(input: String, key: String) {
        markDict[key] = input
        markDict["other_tag"] = ""
    }
}

extension PublishLostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let data = self.function[section]
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UpLoadingCell" + "\(indexPath)") as? UploadingPicCell {
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            } else {
                let cell = UploadingPicCell(style: .default, reuseIdentifier: "UpLoadingCell" + "\(indexPath)")
                
                return cell
            }
        case 5:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LFPickerCell" + "\(indexPath)") as? LFPickerCell {
                let text = function[indexPath.section][indexPath.row]
                if text.last == "*" {
                    let attributedString = NSMutableAttributedString(string: text)
                    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: NSRange(location: text.count - 1, length: 1))
                    cell.textLabel?.attributedText = attributedString
                } else {
                    cell.textLabel?.text = text
                }
                cell.delegate = self
                
                return cell
            } else {
                
                let cell = LFPickerCell(style: .default, reuseIdentifier: "LFPickerCell" + "\(indexPath)")
                let text = function[indexPath.section][indexPath.row]
                if text.last == "*" {
                    let attributedString = NSMutableAttributedString(string: text)
                    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: NSRange(location: text.count - 1, length: 1))
                    cell.textLabel?.attributedText = attributedString
                } else {
                    cell.textLabel?.text = text
                }
                //                cell.textLabel?.text = function[indexPath.section][indexPath.row]
                cell.delegate = self
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PublishLostCell" + "\(indexPath)") as? PublishCustomCell {
                //                tableView.dequeueReusableCell(withIdentifier: , for: indexPath) as? PublishCustomCell {
                cell.selectionStyle = .none
                cell.textField.placeholder = text[indexPath.section]?[indexPath.row]
                cell.textField.becomeFirstResponder()
                cell.textField.returnKeyType = .next
                cell.textField.adjustsFontSizeToFitWidth = true
                cell.textField.minimumFontSize = 14
                cell.textField.delegate = cell
                cell.textField.resignFirstResponder()
                cell.delegate = self
                
                cell.cellkey = returnKeys[indexPath.section]?[indexPath.row]
                
                let string = function[indexPath.section][indexPath.row]
                if string.last == "*" {
                    let attributedString = NSMutableAttributedString(string: string)
                    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: NSRange(location: string.count-1, length: 1))
                    cell.textLabel?.attributedText = attributedString
                } else {
                    cell.textLabel?.text = string
                }
                
                //                cell.textLabel?.text = function[indexPath.section][indexPath.row];
                cell.addTargetMethod()
                cell.textFieldDidEndEditing(cell.textField)
                return cell
                
            } else {
                let cell = PublishCustomCell(style: .default, reuseIdentifier: "PublishLostCell" + "\(indexPath)")
                cell.selectionStyle = .none
                cell.textField.placeholder = text[indexPath.section]?[indexPath.row]
                cell.textField.returnKeyType = .next
                cell.textField.adjustsFontSizeToFitWidth = true
                cell.textField.minimumFontSize = 14
                cell.textField.delegate = cell
                
                cell.delegate = self
                cell.cellkey = returnKeys[indexPath.section]?[indexPath.row]
                cell.addTargetMethod()
                //                cell.textLabel?.text = function[indexPath.section][indexPath.row];
                let string = function[indexPath.section][indexPath.row]
                if string.last == "*" {
                    let attributedString = NSMutableAttributedString(string: string)
                    attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.red], range: NSRange(location: string.count-1, length: 1))
                    cell.textLabel?.attributedText = attributedString
                } else {
                    cell.textLabel?.text = string
                }
                return cell
            }
        }
        
    }
    
}

extension PublishLostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 180
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 6 {
            return 180
        } else if section == 0 {
            return 50
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionCell()
        
        switch section {
        case 0:
            header.label.text = "发布图片"
        case 1:
            header.label.text = "详细信息"
        case 2:
            return mark
        case 3:
            header.label.text = "联系方式"
        case 4:
            header.label.text = "附加信息"
        case 5:
            header.label.text = "发布时长"
        case 6:
            if index == 1 {
                header.label.text = "物品状态"
            } else {
                break
            }
        default:
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 6 {
            let footerView = UIView()
            let trueButton = UIButton()
            trueButton.setTitle("确 定", for: .normal)
            trueButton.setTitleColor(.black, for: .normal)
            trueButton.sizeToFit()
            trueButton.isUserInteractionEnabled = true
            
            trueButton.frame = CGRect(x: self.view.frame.width/2, y: 80, width: 300, height: 40)
            trueButton.center = CGPoint(x: self.view.frame.width/2, y: 60)
            trueButton.backgroundColor = UIColor(hex6: 0x00a1e9)
            trueButton.setTitleColor(.white, for: .normal)
            
            // 为按钮添加圆角
            trueButton.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
            trueButton.layer.borderWidth = 2
            trueButton.layer.cornerRadius = 10
            
            // 为按钮添加阴影
            trueButton.layer.shadowOpacity = 0.8
            trueButton.layer.shadowColor = UIColor.black.cgColor
            trueButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            
            footerView.addSubview(trueButton)
            trueButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
            
            return footerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        // 选择照片or拍照
        case 0:
            self.modalPresentationStyle = .overCurrentContext
            let alertVC = UIAlertController()
            alertVC.view.tintColor = UIColor.black
            let pictureAction = UIAlertAction(title: "从相册中选择图片", style: .default) { _ in
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = .savedPhotosAlbum
                    self.present(imagePicker, animated: true) {
                        
                    }
                }
            }
            let photoAction = UIAlertAction(title: "拍照", style: .destructive) { _ in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true) {
                        
                    }
                }
            }
            //            let detailAction = UIAlertAction(title: "查看大图", style: .default) { _ in
            //
            //            }
            let cencelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertVC.addAction(photoAction)
            alertVC.addAction(pictureAction)
            alertVC.addAction(cencelAction)
            self.present(alertVC, animated: true)
            
        default:
            break
        }
    }
    
}

// Mark -- ImagePickerControllerDelegate
extension PublishLostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UploadingPicCell {
                markDict["pic[]"] = image
                DispatchQueue.main.async {
                    cell.addPictureImage.image = image
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
}

extension PublishLostViewController: UINavigationControllerDelegate {
    
}

// 点击键盘外弹掉键盘，重写UIGestureRecognizerDelegate
extension PublishLostViewController: UIGestureRecognizerDelegate {
    
    func touchOutsideTextField() {
        //        let aSelector: Selector = "closeKeyboard"
        //        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        tapGesture.numberOfTapsRequired = 1
        self.tableView.addGestureRecognizer(tapGesture)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
}
