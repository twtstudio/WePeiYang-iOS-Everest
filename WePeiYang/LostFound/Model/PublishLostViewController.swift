//
//  PublishLostViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Photos


class PublishLostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView: UITableView!
    var markDic:[String: Any] = [:]
    var mark: MarkCustomCell!
    var index = 0
    //    var function = [
    //        0: ["添加图片"],
    //        1: ["标题","时间","地点"],
    //        2: [],
    //        3: ["姓名","联系电话"],
    //        4: ["物品描述"],
    //        5: ["刊登时长"]
    //    ]
    var function = [
        ["添加图片"],
        ["标题*","时间","地点"],
        [],
        ["姓名*","联系电话*"],
        ["物品描述"],
        ["刊登时长*"]
    ]
    
    var text = [
        
        0: [""],
        1: ["(不超过11个字)","请填写详细时间","请填写校区及详细地点"],
        2: ["",""],
        3: ["",""],
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
        ]
    
    var returnKeys = [
        0: ["pic[]"],
        1: ["title","time","place"],
        2: ["card_number","card_name"],
        3: ["name","phone"],
        4: ["item_description"],
        5: ["duration"]
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "捡到物品"
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = UIColor(hex6:  0xeeeeee);
        //        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PublishLostCell");
        
        //        self.tableView.register(SectionCell.self, forHeaderFooterViewReuseIdentifier: "Section")
        //
        //        self.tableView.register(MarkCustomCell.self, forHeaderFooterViewReuseIdentifier: "Mark")
        
        self.tableView.estimatedRowHeight = 500;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.view.addSubview(tableView);
        
        let tableVC = UITableViewController(style: .grouped)
        tableVC.tableView = self.tableView
        self.addChildViewController(tableVC)
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor(hex6: 0x00a1e9)
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.systemFont(ofSize: 15)
        
        //        hide()
        // UIGestureRecognizer截获了touch事件，导致didSelectorRowAtIndexPath无法响应，需要重写UIGestureRecognizerDelegate,在extension中有写到！
        touchOutsideTextField()
        
        let headerMark = MarkCustomCell()
        headerMark.enumerated()
        headerMark.label.text = "类型"
        headerMark.delegate = self
        mark = headerMark
    }
    
    func dismissKeyboard() {
        self.tableView.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let data = self.function[section];
        return data.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
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
        default:
            break
        }
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 180
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 5{
            return 180
        }else if section == 0{
            return 50
        }
        else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
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
            self.present(alertVC, animated: true) {
                print("foo")
            }
            
        default:
            break
        }
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        switch (indexPath.section) {
        case 0:

            if let cell = tableView.dequeueReusableCell(withIdentifier: "UpLoadingCell" + "\(indexPath)") as? UpLoadingPicCell {
                cell.selectionStyle = UITableViewCellSelectionStyle.none

                
                return cell
            } else {
                let cell = UpLoadingPicCell(style: .default, reuseIdentifier: "UpLoadingCell" + "\(indexPath)")

                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PublishLostCell" + "\(indexPath)") as? PublishCustomCell {
                //                tableView.dequeueReusableCell(withIdentifier: , for: indexPath) as? PublishCustomCell {
                cell.selectionStyle = UITableViewCellSelectionStyle.none;
                cell.textField.placeholder = text[indexPath.section]?[indexPath.row]
                cell.textField.becomeFirstResponder();
                cell.textField.returnKeyType = .next;
                cell.textField.adjustsFontSizeToFitWidth = true;
                cell.textField.minimumFontSize = 14;
                cell.textField.delegate = cell;
                cell.textField.resignFirstResponder();
                cell.delegate = self
                
                cell.cellkey = returnKeys[indexPath.section]?[indexPath.row]
                cell.textLabel?.text = function[indexPath.section][indexPath.row];
                cell.addTargetMethod()
                cell.textFieldDidEndEditing(cell.textField)
                return cell
                
            } else {
                let cell = PublishCustomCell(style: .default, reuseIdentifier: "PublishLostCell" + "\(indexPath)")
                cell.selectionStyle = UITableViewCellSelectionStyle.none;
                cell.textField.placeholder = text[indexPath.section]?[indexPath.row]
                //                cell.textField.becomeFirstResponder();
                cell.textField.returnKeyType = .next;
                cell.textField.adjustsFontSizeToFitWidth = true;
                cell.textField.minimumFontSize = 14;
                cell.textField.delegate = cell;
                //                cell.textField.resignFirstResponder();
                
                cell.delegate = self
                
                cell.cellkey = returnKeys[indexPath.section]?[indexPath.row]
                
                cell.addTargetMethod()
                
                
                
                
                
                //             cell.delegate?.fangfa(input: cell.textField.text, key: cell.cellkey)
                
                
                
                cell.textLabel?.text = function[indexPath.section][indexPath.row];
                
                return cell;
            }
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 5 {
            let footerView = UIView()
            let trueButton = UIButton()
            trueButton.setTitle("确 定", for:UIControlState.normal)
            trueButton.setTitleColor(UIColor.black,for: .normal)
            trueButton.sizeToFit()
            trueButton.isUserInteractionEnabled = true
            
            trueButton.frame = CGRect(x: self.view.frame.width/2, y: 80, width: 300, height: 40)
            trueButton.center = CGPoint(x: self.view.frame.width/2, y: 60)
            trueButton.backgroundColor = UIColor(hex6: 0x00a1e9)
            trueButton.setTitleColor(.white, for: .normal)
            //为按钮添加圆角
            trueButton.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
            trueButton.layer.borderWidth = 2
            trueButton.layer.cornerRadius = 10
            //为按钮添加阴影
            trueButton.layer.shadowOpacity = 0.8
            trueButton.layer.shadowColor = UIColor.black.cgColor
            trueButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            
            footerView.addSubview(trueButton)
            trueButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
            
            print(index)
            //
            if index == 1 {
               let deleteButton = UIButton(frame: CGRect(x: self.view.frame.width/2, y: 80, width: 300, height: 40))
                deleteButton.center = CGPoint(x: self.view.frame.width/2, y: 120)
                deleteButton.backgroundColor = .red
                deleteButton.setTitle("删 除", for: .normal)
                deleteButton.layer.borderColor = UIColor.red.cgColor
                deleteButton.layer.borderWidth = 2
                deleteButton.layer.cornerRadius = 10
                deleteButton.layer.shadowOpacity = 0.8
                deleteButton.layer.shadowColor = UIColor.black.cgColor
                deleteButton.layer.shadowOffset = CGSize(width: 1, height: 1)

                footerView.addSubview(deleteButton)
            
            }
            return footerView
        }
        else{
            return nil
        }
    }
    
    func tapped(){
        
        print("Release success")
        print(markDic)
        //        LostAPI.fabu(markdic: markdic, success: {
        //            _ in
        //        })
        
        //        if let image = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UpLoadingPicCell)?.addPictureImage.image {
        //            markDic["pic[]"] = image
//        if (markDic["title"] == "" || markDic["detail_type"] == "" || markDic["name"] == "" || markDic["phone"] == "" || markDic["duration"]) {
//            
//            
//        }
        PostLostAPI.postLost(markDic: markDic, success: {
            
            dic in
            let successVC = PublishSuccessViewController()
            self.navigationController?.pushViewController(successVC, animated: true)
        }, failure: { error
            in
            print(error)
        })
        //        }
        print(markDic)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    func comfirmButtonTapped() {
        //        LostAPI.fabu(name: )
    }
    
    func means(input:String,key:String){
        //        var markdic:[String: String] = [:]
        
        
        
        markDic[key] = input
        markDic["other_tag"] = ""
        
    }
    
    
}

// Mark -- ImagePickerControllerDelegate
extension PublishLostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            
            
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UpLoadingPicCell {
                markDic["pic[]"] = image
                DispatchQueue.main.async {
                    cell.addPictureImage.image = image
                }
                //                cell.addPictureImage.image = image
                
                
            }
 
        }
        
        //            cell.addPictureImage.image = image
        //            var v: UIView?
        //            v = UIImageView()
        //            if let v = v as? UIImageView {
        //            }
        
        //            self.tableView.reloadData()
        
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


