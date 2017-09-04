//
//  PublishLostViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Photos


class PublishLostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var tableView: UITableView!;
    var markDic:[String: String] = [:]
    var mark: MarkCustomCell!
    
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
        ["标题","时间","地点"],
        [],
        ["姓名","联系电话"],
        ["物品描述"],
        ["刊登时长"]
    ]
    
    var text = [
        
        0: [""],
        1: ["(不超过11个字)","请填写详细时间","请填写校区及详细地点"],
        2: ["",""],
        3: ["",""],
        4: ["请认真填写物品信息","（如果你“类型“一栏选择”其他“,您可以在这里填写具体类型）"],
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
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = UIColor(hex6: 0x00a1e9)
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.systemFont(ofSize: 15)
        
        
        let headerMark = MarkCustomCell()
        headerMark.enumerated()
        headerMark.label.text = "类型"
        headerMark.delegate = self
        mark = headerMark
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
            return 120
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
            let detailAction = UIAlertAction(title: "查看大图", style: .default) { _ in
                
            }
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
            let cell = UpLoadingPicCell()
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            
            
            return cell
            
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PublishLostCell" + "\(indexPath)") as? PublishCustomCell {
//                tableView.dequeueReusableCell(withIdentifier: , for: indexPath) as? PublishCustomCell {
                cell.selectionStyle = UITableViewCellSelectionStyle.none;
                cell.textField.placeholder = text[indexPath.section]?[indexPath.row]
                cell.textField.becomeFirstResponder();
                cell.textField.returnKeyType = .done;
                cell.textField.adjustsFontSizeToFitWidth = true;
                cell.textField.minimumFontSize = 14;
                cell.textField.delegate = cell;
                cell.textField.resignFirstResponder();
                cell.delegate = self
                
                cell.cellkey = returnKeys[indexPath.section]?[indexPath.row]
                cell.textLabel?.text = function[indexPath.section][indexPath.row];
                return cell
                
            } else {
                let cell = PublishCustomCell(style: .default, reuseIdentifier: "PublishLostCell" + "\(indexPath)")
                cell.selectionStyle = UITableViewCellSelectionStyle.none;
                cell.textField.placeholder = text[indexPath.section]?[indexPath.row]
                cell.textField.becomeFirstResponder();
                cell.textField.returnKeyType = .done;
                cell.textField.adjustsFontSizeToFitWidth = true;
                cell.textField.minimumFontSize = 14;
                cell.textField.delegate = cell;
                cell.textField.resignFirstResponder();
                
                cell.delegate = self
                
                cell.cellkey = returnKeys[indexPath.section]?[indexPath.row]
                
                
                
                
                
                
                
                //             cell.delegate?.fangfa(input: cell.textField.text, key: cell.cellkey)
                
                
                
                cell.textLabel?.text = function[indexPath.section][indexPath.row];
                
                return cell;
            }
            
//            let cell = PublishCustomCell()
//            cell.selectionStyle = UITableViewCellSelectionStyle.none;
//            cell.textField.placeholder = text[indexPath.section]?[indexPath.row]
//            cell.textField.becomeFirstResponder();
//            cell.textField.returnKeyType = .done;
//            cell.textField.adjustsFontSizeToFitWidth = true;
//            cell.textField.minimumFontSize = 14;
//            cell.textField.delegate = cell;
//            cell.textField.resignFirstResponder();
//            cell.delegate = self
//            
//            cell.cellkey = returnKeys[indexPath.section]?[indexPath.row]

            
            
            
            
            
            
//             cell.delegate?.fangfa(input: cell.textField.text, key: cell.cellkey)
            
            
            
//            cell.textLabel?.text = function[indexPath.section][indexPath.row];
//            
//            return cell;
            
            
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 5 {
            let footerView = UIView()
            let button = UIButton()
            button.setTitle("确定", for:UIControlState.normal)
            button.setTitleColor(UIColor.black,for: .normal)
            button.sizeToFit()
            button.isUserInteractionEnabled = true
            
            button.frame = CGRect(x: self.view.frame.width/2, y: 80, width: 300, height: 40)
            button.center = CGPoint(x: self.view.frame.width/2, y: 60)
            button.backgroundColor = UIColor(hex6: 0x00a1e9)
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 10
            //为按钮添加阴影
            button.layer.shadowOpacity = 0.8
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 1, height: 1)
            
            footerView.addSubview(button)
            button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
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
        PostLostAPI.postLost(markDic: markDic, success: {
            dic in
            let successVC = PublishSuccessViewController()
            self.navigationController?.pushViewController(successVC, animated: true)
        }, failure: { error in
            print(error)
        })
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //
    //
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    //
    //        textField.resignFirstResponder();
    //        return true;
    //    
    //    }
    
    func comfirmButtonTapped() {
        //        LostAPI.fabu(name: )
    }
    
    func means(input:String,key:String){
        //        var markdic:[String: String] = [:]
        
        
        
        markDic[key] = input
        markDic["other_tag"] = ""
        
    }
 
    
}
extension PublishLostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {

            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension PublishLostViewController: UINavigationControllerDelegate {

}
