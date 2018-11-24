//
//  LibraryBorrowViewController.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/26.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SDWebImage
import PopupDialog
import SnapKit

class LibraryBorrowViewController: UIViewController {
    private let bookCollectionCellID = "bookCollectionCell"
    
    private lazy var bookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height * 0.65)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height * 0.65), collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = LibraryMainViewController.bgColor
        collection.register(BookCollectionCell.self, forCellWithReuseIdentifier: bookCollectionCellID)
        return collection
    }()
    
    private lazy var pageControl: LibraryPageControl = {
        let pageControl = LibraryPageControl()
        pageControl.numberOfPages = LibraryDataContainer.shared.books.count
        pageControl.currentPage = 0
        pageControl.frame = CGRect(x: view.bounds.origin.x, y: bookCollectionView.frame.origin.y + bookCollectionView.frame.height, width: view.bounds.width, height: view.bounds.height * 0.05)
        pageControl.isUserInteractionEnabled = false
        pageControl.setImage(pageImage: #imageLiteral(resourceName: "page"), currentPageImage: #imageLiteral(resourceName: "currentPage"))
        return pageControl
    }()
    
    private lazy var button: CardButton = {
        let button = CardButton()
        button.frame = CGRect(x: view.bounds.width * 0.25, y: pageControl.frame.origin.y + pageControl.frame.height + bookCollectionView.frame.width * 0.03, width: view.bounds.width * 0.5, height: view.bounds.height * 0.08)
        button.backgroundColor = LibraryMainViewController.mainColor
        button.setTitle("一键续借", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        button.layer.cornerRadius = 4.0
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        //        let insertH = navigationBarH + statusH  + 40
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        let image = #imageLiteral(resourceName: "没有借书")
        //        let scale = image.size.height / image.size.width
        //        var originY = (view.bounds.height - image.size.height + insertH) / 2
        //        originY = originY > 0 ? originY : -originY
        //        let imgFrame = CGRect(x: view.bounds.origin.x, y: originY, width: view.bounds.width, height: view.bounds.width * scale)
        //        imageView.frame = imgFrame
        imageView.image = image
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LibraryMainViewController.bgColor
        if LibraryDataContainer.shared.books.isEmpty {
            view.addSubview(imageView)
            imageView.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(view)
                make.width.equalTo(view)
                make.centerY.equalTo(view)
            }
        } else {
            view.addSubview(bookCollectionView)
            view.addSubview(pageControl)
            view.addSubview(button)
            button.addTarget(self, action: #selector(renew(sender:)), for: .touchUpInside)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LibraryBorrowViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LibraryDataContainer.shared.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bookCollectionCellID, for: indexPath) as! BookCollectionCell
        cell.bookCard.book =  LibraryDataContainer.shared.books[indexPath.item % LibraryDataContainer.shared.books.count]
        return cell
    }
}

extension LibraryBorrowViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % LibraryDataContainer.shared.books.count
        pageControl.layoutSubviews()
    }
}

extension LibraryBorrowViewController {
    // MARK: 复制了一遍续借代码 窒息
    @objc func renew(sender: CardButton) {
        let popup = PopupDialog(title: "注意", message: "每个月只能续借一次\n存在逾期未还书籍不能续借")
        let okButton = DefaultButton(title: "好的") {
            let group = DispatchGroup()
            var count = 0
            for book in LibraryDataContainer.shared.books {
                group.enter()
                SolaSessionManager.solaSession(type: .get, url: "/library/renew/\(book.barcode)", token: "", parameters: nil, success: { _ in
                    // TODO: Check
                    count += 1
                    group.leave()
                }, failure: { err in
                    group.leave()
                    SwiftMessages.showErrorMessage(body: err.localizedDescription)
                })
            }
            group.notify(queue: .main, execute: {
                SwiftMessages.showSuccessMessage(body: "已续借\(count)本书")
                self.getBooks(success: {
                    self.bookCollectionView.reloadData()
                })
            })
        }
        popup.addButton(okButton)
        UIViewController.current?.present(popup, animated: true, completion: nil)
    }
    
    func getBooks(success: (() -> Void)? = nil) {
        SolaSessionManager.solaSession(type: .get, url: "/library/user/info", token: "", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? LibraryResponse(data: data) {
                LibraryDataContainer.shared.response = response
                self.bookCollectionView.reloadData()
                CacheManager.store(object: response, in: .group, as: "lib/info.json")
                success?()
            } else {
            }
        }, failure: { _ in
        })
    }
}
extension UIPageControl {
    func setImage(pageImage: UIImage, currentPageImage: UIImage) {
        var ivarNamePageControl: [String] = []
        
        var count: uint = 0
        let list = class_copyIvarList(UIPageControl.classForCoder(), &count)
        
        for index in 0 ... count-1 {
            let ivarName = ivar_getName( (list?[ Int(index) ])! )
            let name = String.init(cString: ivarName!)
            ivarNamePageControl.append(name)
        }
        
        if ivarNamePageControl.contains("_pageImage") && ivarNamePageControl.contains("_currentPageImage") {
            self.setValue(pageImage, forKey: "_pageImage")
            self.setValue(currentPageImage, forKey: "_currentPageImage")
        }
    }
}
