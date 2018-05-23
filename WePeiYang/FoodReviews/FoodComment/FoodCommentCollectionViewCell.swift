//
//  CollectionViewController.swift
//  Comment
//
//  Created by yuting jiang on 2018/5/2.
//  Copyright © 2018年 yuting jiang. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

var contentViewH = 0
class TableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let titleVIewW = sWid * 0.85
    let picButtonW = Int((sWid * 0.8) / 3)
    
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentViewH = picButtonW
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.itemSize = CGSize(width: picButtonW, height: picButtonW)
        selectionStyle = .none
        contentView.backgroundColor = bgColor
        collectionView = UICollectionView(frame: CGRect(x: Int(sWid - titleVIewW) / 2, y: Int(0.1 * Float(picButtonW)), width: Int(titleVIewW), height: contentViewH), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = UIColor.clear
        
        self.addSubview(collectionView)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if updatePic.count < 1 {
            return 1
        } else {
            return updatePic.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        let imageView = UIImageView()
        cell.layer.cornerRadius = 3
        cell.contentView.addSubview(imageView)
        switch indexPath.item {
        case updatePic.count:
            cell.contentView.layer.borderColor = normalGray.cgColor
            cell.contentView.layer.borderWidth = 1
            imageView.snp.makeConstraints { (make) in
                make.width.equalTo(0.2 * Double(picButtonW))
                make.height.equalTo(0.2 * Double(picButtonW))
                make.height.equalTo(picButtonW)
                make.center.equalTo(cell.contentView)
            }
            imageView.image = #imageLiteral(resourceName: "plus16")
            return cell
        default:
            let closeBtnH = picButtonW / 8
            cell.backgroundColor = normalGray
            imageView.snp.makeConstraints { (make) in
                make.width.equalTo(picButtonW)
                make.height.equalTo(picButtonW)
                make.height.equalTo(picButtonW)
                make.center.equalTo(cell.contentView)
            }
            imageView.image = updatePic[indexPath.item]
            
            let closeButton: UIButton = {
                let button = UIButton()
                button.setImage(#imageLiteral(resourceName: "plus16"), for: .normal)
                button.backgroundColor = .red
                button.addTarget(self, action:#selector(deletePic(sender:)) , for: .touchUpInside)
                return button
            }()
            closeButton.tag = indexPath.item
            //            deleteBtn.append(closeButton)
            cell.contentView.addSubview(closeButton)
            closeButton.snp.makeConstraints { (make) in
                make.centerX.equalTo(picButtonW)
                make.centerY.equalTo(closeBtnH)
                make.height.equalTo(closeBtnH)
                make.width.equalTo(closeBtnH)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case updatePic.count:
            addPhoto()
            print("update", updatePic.count)
            reload()
            return
        default:
            return
        }
    }
    
    func addPhoto() {
        //1.判断照片控制器是否可用 ,不可用返回
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print(2)
            return
        }
        print(1)
        //2.创建照片控制器
        let picVc = UIImagePickerController()
        //3.设置控制器类型
        picVc.sourceType = .photoLibrary
        //4.设置是否可以管理已经存在的图片或者视频
        picVc.allowsEditing = true
        //5.设置代理
        picVc.delegate = self
        //6.弹出控制器
        let topVC = topMostController()
        topVC.present(picVc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ pickVc: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选择的原图
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        print("rootPath: \n", rootPath)
        
        let filePath = "\(rootPath)/pickedimage.jpg"
        let imageData = UIImageJPEGRepresentation(pickedImage, 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        //上传图片
        if (fileManager.fileExists(atPath: filePath)){
            //取得NSURL
            let imageURL = URL(fileURLWithPath: filePath)
            print(imageURL)
            //使用Alamofire上传
            //                        Alamofire.upload(imageURL, to: "")
            //                            .responseString { response in
            //                                print("Success: \(response.result.isSuccess)")
            //                                print("Response String: \(response.result.value ?? "")")
            //                        }
            let image = UIImage(data: imageData!)
            updatePic.append(image!)
            updatePicUrl.append(imageURL)
            reload()
        }
        //图片控制器退出
        pickVc.dismiss(animated: true, completion:nil)
    }
    
    @objc func deletePic(sender: UIButton) {
        print(sender.tag)
        self.collectionView.performBatchUpdates({
            let fileManager = FileManager.default
            //            try! fileManager.removeItem(at: updatePicUrl[sender.tag])
            
            updatePic.remove(at: sender.tag)
            updatePicUrl.remove(at: sender.tag)
            
            let indexPath = IndexPath.init(item: sender.tag, section: 0)
            print(indexPath)
            let arr: [IndexPath] = [indexPath]
            self.collectionView?.deleteItems(at: arr)
        }) { (completion) in
            self.collectionView.reloadData()
        }
    }
    
    func reload() {
        if updatePic.count > 3 {
            contentViewH = Int(Double(2 * contentViewH) + 0.05 * sWid)
        }
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        return topController
    }
}








