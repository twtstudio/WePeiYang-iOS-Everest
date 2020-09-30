//
//  FBPhotoCollectionView.swift
//  WePeiYang
//
//  Created by Zr埋 on 2020/9/27.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SKPhotoBrowser

private let reuseIdentifier = "FBPCVCCell"

class FBPhotoCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
     
     var images: [UIImage]? {
          didSet {
               reloadData()
          }
     }
     var thumbUrls: [String]? {
          didSet {
               reloadData()
          }
     }
     var urls: [String]? {
          didSet {
               reloadData()
          }
     }
     
     init(size: CGSize = .zero) {
          let layout = UICollectionViewFlowLayout()
          layout.itemSize = size == .zero ? CGSize(width: 100, height: 100) : size
          layout.minimumLineSpacing = 0
          layout.minimumInteritemSpacing = 0
          layout.scrollDirection = .horizontal
          
          super.init(frame: .zero, collectionViewLayout: layout)
          showsHorizontalScrollIndicator = false
          backgroundColor = .white
          self.images = [UIImage(named: "feedback_choose_pic")!]
          tag = 3 // means addingmode
          register(FBPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
          delegate = self
          dataSource = self
     }
     
     init(images: [UIImage], size: CGSize = .zero) {
          
          let layout = UICollectionViewFlowLayout()
          layout.itemSize = size == .zero ? CGSize(width: 100, height: 100) : size
          layout.minimumLineSpacing = 0
          layout.minimumInteritemSpacing = 0
          layout.scrollDirection = .horizontal
          
          super.init(frame: .zero, collectionViewLayout: layout)
          showsHorizontalScrollIndicator = false
          backgroundColor = .white
          self.images = images
          tag = 0 // means use imgs
          register(FBPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
          delegate = self
          dataSource = self
     }
     
     init(thumbUrls: [String], urls: [String], size: CGSize = .zero) {
          let layout = UICollectionViewFlowLayout()
          layout.itemSize = size == .zero ? CGSize(width: 100, height: 100) : size
          layout.minimumLineSpacing = 0
          layout.minimumInteritemSpacing = 0
          layout.scrollDirection = .horizontal
          
          super.init(frame: .zero, collectionViewLayout: layout)
          showsHorizontalScrollIndicator = false
          backgroundColor = .white
          self.thumbUrls = thumbUrls
          self.urls = urls
          tag = 1 // means use urls
          register(FBPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
          delegate = self
          dataSource = self
     }
     
     func reload(_ images: [UIImage]) {
          self.images = images
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
}

//MARK: - Delegate
extension FBPhotoCollectionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return tag == 1 ? urls?.count ?? 0 : images?.count ?? 0
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FBPhotoCollectionViewCell
          if tag == 1 {
               cell.imgView.sd_setImage(with: URL(string: thumbUrls?[indexPath.row] ?? "")!, completed: nil)
          } else {
               cell.imgView.image = images?[indexPath.row]
          }
          return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          var topVC = UIApplication.shared.keyWindow?.rootViewController
          while((topVC!.presentedViewController) != nil) {
               topVC = topVC!.presentedViewController
          }
          if collectionView.tag == 3 {
               
               if indexPath.row == (self.images?.count ?? 1) - 1 {
                    guard (self.images?.count ?? 1) != 4 else {
                         let alert = UIAlertController(title: "警告", message: "你最多可以添加三张图片", preferredStyle: .alert)
                         let action1 = UIAlertAction(title: "好", style: .default)
                         alert.addAction(action1)
                         topVC?.present(alert, animated: true)
                         return
                    }
                    
                    topVC?.modalPresentationStyle = .overCurrentContext
                    let alertVC = UIAlertController()
                    alertVC.view.tintColor = UIColor.black
                    let pictureAction = UIAlertAction(title: "从相册中选择图片", style: .default) { _ in
                         if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                              
                              let imagePicker = UIImagePickerController()
                              imagePicker.delegate = self
                              imagePicker.allowsEditing = true
                              imagePicker.sourceType = .photoLibrary
                              topVC?.present(imagePicker, animated: true)
                         }
                    }
                    let photoAction = UIAlertAction(title: "拍照", style: .default) { _ in
                         if UIImagePickerController.isSourceTypeAvailable(.camera) {
                              
                              let imagePicker = UIImagePickerController()
                              imagePicker.delegate = self
                              imagePicker.allowsEditing = true
                              imagePicker.sourceType = .camera
                              topVC?.present(imagePicker, animated: true)
                         }
                    }
                    let cencelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alertVC.addAction(photoAction)
                    alertVC.addAction(pictureAction)
                    alertVC.addAction(cencelAction)
                    topVC?.present(alertVC, animated: true)
               } else {
                    let alert = UIAlertController(title: "警告", message: "你正在删除这张图片, 是否继续?", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let action2 = UIAlertAction(title: "确认", style: .destructive) { (_) in
                         self.images?.remove(at: indexPath.row)
                    }
                    alert.addAction(action1)
                    alert.addAction(action2)
                    
                    topVC?.present(alert, animated: true)
               }
          }
          else if collectionView.tag == 1 {
               var images = [SKPhoto]()
               for url in self.urls ?? [] {
                    images.append(SKPhoto.photoWithImageURL(url))
               }
               
               let browser = SKPhotoBrowser(photos: images)
               SKPhotoBrowserOptions.displayAction = false
               browser.initializePageIndex(indexPath.row)
               topVC?.present(browser, animated: true, completion: {})
          }
     }
     
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          guard let selectedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
               print("image trans error")
               return
          }
          picker.dismiss(animated: true) {
               let idx = (self.images?.count ?? 1) - 1
               self.images?.insert(selectedImg, at: idx)
          }
     }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
     }
}
